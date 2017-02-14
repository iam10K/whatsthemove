//
//  Event.swift
//  WhatsTheMove
//
//  Created by Tyler Encke on 9/27/16.
//  Copyright © 2016 WhatsTheMove. All rights reserved.
//

import UIKit
import Firebase

class Event: NSObject {
    
    var ref: FIRDatabaseReference?
    
    var key: String = ""
    
    var checkedIn: Int = 0
    var createdDate: Date = Date()
    var creatorId: String = ""
    var endDate: Date = Date()
    var ended: Bool = false
    var entryNote: String = ""
    var eventDescription: String = ""
    var friendsCanInvite: Bool = true
    var interested: Int = 0
    var location: EventLocation = EventLocation()
    var privacyLevel: Int = 0
    var rating: Int = 0
    var sponsor: String = ""
    var startDate: Date = Date()
    var title: String = ""
    
    var comments: [Comment] = []
    
    var userRating: Bool?
    
    public override init() {
        super.init()
        
        endDate = createDate()
        startDate = createDate()
    }
    
    public init(snapshot: FIRDataSnapshot) {
        super.init()
        
        ref = snapshot.ref
        
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        key = snapshot.key
        
        if let checkedInValue = snapshotValue["checkedIn"] as? Int {
            checkedIn = checkedInValue
        }
        
        if let createdDateValue = snapshotValue["createdDate"] as? Double {
            createdDate = Date(timeIntervalSince1970: createdDateValue)
        }
        
        if let creatorIdValue = snapshotValue["creatorId"] as? String {
            creatorId = creatorIdValue
        }
        
        if let endDateValue = snapshotValue["endDate"] as? Double {
            endDate = Date(timeIntervalSince1970: endDateValue)
        }
        
        if let endedValue = snapshotValue["ended"] as? Int {
            ended = endedValue == 0 ? false : true
        }
        
        if let entryNoteValue = snapshotValue["entryNote"] as? String {
            entryNote = entryNoteValue
        }
        
        if let eventDescriptionValue = snapshotValue["eventDescription"] as? String {
            eventDescription = eventDescriptionValue
        }
        
        if let friendsCanInviteValue = snapshotValue["friendsCanInvite"] as? Int {
            friendsCanInvite = friendsCanInviteValue == 0 ? false : true
        }
        
        if let interestedValue = snapshotValue["interested"] as? Int {
            interested = interestedValue
        }
        
        if let locationValues = snapshotValue["location"] as? [String: AnyObject] {
            location = EventLocation(values: locationValues)
        }
        
        if let privacyLevelValue = snapshotValue["privacyLevel"] as? Int {
            privacyLevel = privacyLevelValue
        }
        
        if let ratingValue = snapshotValue["rating"] as? Int {
            rating = ratingValue
        }
        
        if let sponsorValue = snapshotValue["sponsor"] as? String {
            sponsor = sponsorValue
        }
        
        if let startDateValue = snapshotValue["startDate"] as? Double {
            startDate = Date(timeIntervalSince1970: startDateValue)
        }
        
        if let titleValue = snapshotValue["title"] as? String {
            title = titleValue
        }
        
        loadComments()
    }
    
    func clear() {
        checkedIn = 0
        creatorId = ""
        ended = false
        endDate = createDate()
        entryNote = ""
        eventDescription = ""
        location = EventLocation()
        friendsCanInvite = true
        interested = 0
        privacyLevel = 0
        sponsor = ""
        startDate = createDate()
        title = ""
    }
    
    private func createDate() -> Date {
        let curCalendar = Calendar.current
        let dateComponents = curCalendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date() as Date)
        
        // Get all values for new date
        let year =  dateComponents.year
        let month = dateComponents.month
        let day = dateComponents.day
        let hour =  dateComponents.hour
        var minute = dateComponents.minute
        
        if minute! >= 30 {
            minute = 30
        } else {
            minute = 0
        }
        
        // Create new date from components
        var selectedComponents = DateComponents()
        selectedComponents.year = year
        selectedComponents.month = month
        selectedComponents.day = day
        selectedComponents.hour = hour
        selectedComponents.minute = minute
        if let date = curCalendar.date(from: selectedComponents) {
            return date
        }
        return Date()
    }
    
    func loadComments() {
        // Listen for new events
        if let ref = ref {
            var commentsQuery = ref.root.child("comments").child(key).queryOrdered(byChild: "createdDate")
            if let lastComment = comments.last {
                commentsQuery = commentsQuery.queryStarting(atValue: lastComment.key)
            }
            
            commentsQuery.observe(.value, with: { snapshot in
                for comment in snapshot.children {
                    let commentObject = Comment(snapshot: comment as! FIRDataSnapshot)
                    self.comments.append(commentObject)
                }
            })
        }
    }
    
    // Set the users rating of event
    func rateEvent(ofUser user: String, vote: Bool, ratingLabel: UILabel? = nil, completionHandler: (() -> Void)? = nil) {
        // Keep track if user is changing vote. If so increment/decrement by 2 instead of 1
        var changingVote = false
        if let userRating = userRating {
            if userRating == vote {
                return
            } else {
                changingVote = true
            }
        }
        userRating = vote
        
        let WTM = WTMSingleton.instance
        WTM.dbRef.child("eventLikes").child(key).child(user).setValue(vote)
        
        if let ref = ref {
            ref.child("rating").runTransactionBlock({ (ratingValue) -> FIRTransactionResult in
                if var newRating = ratingValue.value as? Int {
                    let voteInt = vote ? 1 : -1
                    if changingVote {
                        newRating += voteInt * 2
                    } else {
                        newRating += voteInt * 1
                    }
                    ratingValue.value = newRating
                    return FIRTransactionResult.success(withValue: ratingValue)
                } else {
                    return FIRTransactionResult.success(withValue: ratingValue)
                }
            }, andCompletionBlock: { (error, completion, snap) in
                if let error = error {
                    // TODO: Handle failed vote? reset userRating, show message?
                    print(error.localizedDescription)
                }
                if !completion {
                    print("Not completed")
                } else if let snap = snap {
                    // Update rating for event object
                    if let ratingValue = snap.value as? Int {
                        self.rating = ratingValue
                        completionHandler?()
                        // If ratingLabel is specified update the label
                        if let ratingLabel = ratingLabel {
                            ratingLabel.text = String(self.rating)
                        }
                    }
                }
            })
        }
    }
    
    // Get the rating by the current user, if any
    func updateRatingArrows(ofUser user: String, upButton: UIButton, downButton: UIButton) {
        if let userRating = userRating {
            setRating(rating: userRating, upButton: upButton, downButton: downButton)
        } else {
            let WTM = WTMSingleton.instance
            WTM.dbRef.child("eventLikes").child(key).child(user).observeSingleEvent(of: .value, with: { (snapshot) in
                if let rating = snapshot.value as? Bool {
                    self.userRating = rating
                    self.setRating(rating: rating, upButton: upButton, downButton: downButton)
                }
            })
        }
    }
    
    // Set the tint for buttons based on user rating
    private func setRating(rating: Bool, upButton: UIButton, downButton: UIButton) {
        if rating {
            changeTint(forButton: upButton, toColor: UIColor.green, withImage: #imageLiteral(resourceName: "arrow-up"))
            changeTint(forButton: downButton, toColor: nil, withImage: #imageLiteral(resourceName: "arrow-down"))
        } else {
            changeTint(forButton: upButton, toColor: nil, withImage: #imageLiteral(resourceName: "arrow-up"))
            changeTint(forButton: downButton, toColor: UIColor.green, withImage: #imageLiteral(resourceName: "arrow-down"))
        }
    }
    
    // Change the tint and image of a button
    func changeTint(forButton button: UIButton, toColor color: UIColor? = nil, withImage image: UIImage) {
        var newImage = image.withRenderingMode(.alwaysTemplate)
        if color == nil {
            newImage = image
        }
        button.setImage(newImage, for: .normal)
        button.tintColor = color
    }
    
    // Check the user into event, does not check if the event is occuring
    func checkin(user: String, completionHandler: (() -> Void)? = nil) {
        let WTM = WTMSingleton.instance
        
        WTM.dbRef.child("checkedIn").child(key).child(user).observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() {
                
                // Validate ref and that the user has not checked in
                if let ref = self.ref {
                    ref.child("checkedIn").runTransactionBlock({ (checkedInValue) -> FIRTransactionResult in
                        if let newCheckedIn = checkedInValue.value as? Int {
                            checkedInValue.value = newCheckedIn + 1
                            return FIRTransactionResult.success(withValue: checkedInValue)
                        } else {
                            return FIRTransactionResult.success(withValue: checkedInValue)
                        }
                    }, andCompletionBlock: { (error, completion, snap) in
                        if let error = error {
                            // TODO: Handle failed vote? reset userRating, show message?
                            print(error.localizedDescription)
                        }
                        if !completion {
                            print("Not completed")
                        } else if let snap = snap {
                            // TODO: Check if user is near location, task for later
                            // FUTURE: Possibly include user name for performance increase(less connections to database)
                            WTM.dbRef.child("checkedIn").child(self.key).child(user).setValue(
                                ["date": Date().timeIntervalSince1970,
                                 "atLocation": false])
                            
                            // Update rating for event object
                            if let checkedInValue = snap.value as? Int {
                                self.checkedIn = checkedInValue
                                completionHandler?()
                            }
                        }
                    })
                }
            }
        })
    }
    
    // Check the user into event
    func interest(user: String, completionHandler: (() -> Void)? = nil) {
        let WTM = WTMSingleton.instance
        
        var removingInterest = false
        
        WTM.dbRef.child("interested").child(key).child(user).observeSingleEvent(of: .value, with: { (snapshot) in
            // If user has not said interested in, add to the interested in
            if snapshot.exists() {
                if let hasInterest = snapshot.value as? Bool {
                    if hasInterest {
                        removingInterest = true
                    }
                }
            }
            
            // Validate ref and update # of users interested
            if let ref = self.ref {
                ref.child("interested").runTransactionBlock({ (interestedValue) -> FIRTransactionResult in
                    if let newInterested = interestedValue.value as? Int {
                        if removingInterest {
                            interestedValue.value = newInterested - 1
                        } else {
                            interestedValue.value = newInterested + 1
                        }
                        return FIRTransactionResult.success(withValue: interestedValue)
                    } else {
                        return FIRTransactionResult.success(withValue: interestedValue)
                    }
                }, andCompletionBlock: { (error, completion, snap) in
                    if let error = error {
                        // TODO: Handle failed vote? reset userRating, show message?
                        print(error.localizedDescription)
                    }
                    if !completion {
                        print("Not completed")
                    } else if let snap = snap {
                        // FUTURE: Possibly include user name for performance increase(less connections to database)
                        if !removingInterest {
                            WTM.dbRef.child("interested").child(self.key).child(user).setValue(true)
                        }
                        
                        // Update rating for event object
                        if let interestedValue = snap.value as? Int {
                            self.interested = interestedValue
                            completionHandler?()
                        }
                    }
                })
            }
            
            if removingInterest {
                // Remove from DB
                WTM.dbRef.child("interested").child(self.key).child(user).removeValue()
            }
            
        })
    }
    
    // TODO: If the event is occuring or not
    func isOccuring() -> Bool {
        return true
    }
    
    // TODO: If the event is going to occur in the future
    func willOccur() -> Bool {
        return false
    }
    
    func toAnyObject() -> [AnyHashable: Any] {
        return [
            "checkedIn": checkedIn,
            "createdDate": createdDate.timeIntervalSince1970,
            "creatorId": creatorId,
            "description": eventDescription,
            "endDate": endDate.timeIntervalSince1970,
            "ended": ended ? 1 : 0,
            "entryNote": entryNote,
            "friendsCanInvite": friendsCanInvite ? 1 : 0,
            "interested": interested,
            "location": location.toAnyObject(),
            "privacyLevel": privacyLevel,
            "rating": rating,
            "sponsor": sponsor,
            "startDate": startDate.timeIntervalSince1970,
            "title": title
        ]
    }
    
    func toJSONString() -> String {
        return "[" +
            "\n\"checkedIn\": \(checkedIn)," +
            "\n\"createdDate\": \(createdDate.timeIntervalSince1970)," +
            "\n\"creatorId\": \(creatorId)," +
            "\n\"description\": \(eventDescription)," +
            "\n\"endDate\": \(endDate.timeIntervalSince1970)," +
            "\n\"ended\": \(ended)," +
            "\n\"entryNote\": \(entryNote)," +
            "\n\"friendsCanInvite\": \(friendsCanInvite ? 1 : 0)," +
            "\n\"interested\": \(interested)," +
            "\n\"location\": \(location.toJSONString())," +
            "\n\"privacyLevel\": \(privacyLevel)," +
            "\n\"rating\": \(rating)," +
            "\n\"sponsor\": \(sponsor)," +
            "\n\"startDate\": \(startDate.timeIntervalSince1970)," +
            "\n\"title\": \(title)" +
        "\n]"
    }
}
