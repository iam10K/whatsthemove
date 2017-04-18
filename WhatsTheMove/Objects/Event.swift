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
        
        createDates()
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
        
        if let eventDescriptionValue = snapshotValue["description"] as? String {
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
        comments = []
        creatorId = ""
        ended = false
        entryNote = ""
        eventDescription = ""
        location = EventLocation()
        friendsCanInvite = true
        interested = 0
        privacyLevel = 0
        sponsor = ""
        title = ""
        createDates()
    }
    
    private func createDates() {
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
            startDate = date
            endDate = date
        } else {
            let genericDate = Date()
            startDate = genericDate
            endDate = genericDate
        }
    }
    
    func loadComments() {
        // Listen for new events
        if let ref = ref {
            let commentsQuery = ref.root.child("comments").child(key)
            /*.queryOrdered(byChild: "createdDate").queryLimited(toFirst: 10)
             if let lastComment = comments.last {
             commentsQuery = commentsQuery.queryStarting(atValue: lastComment.key)
             }*/
            
            commentsQuery.observe(.value, with: { snapshot in
                for comment in snapshot.children {
                    let commentObject = Comment(snapshot: comment as! FIRDataSnapshot)
                    self.addComment(commentObject)
                }
            })
        }
    }
    
    func addComment(_ comment: Comment) {
        var foundComment: Comment? = getComment(comment.key)
        // If comment is new just add it. If not then replace the original
        if foundComment == nil {
            comments.append(comment)
        } else {
            foundComment = comment
        }
    }
    
    func getComment(_ key: String) -> Comment? {
        for comment in comments {
            if comment.key == key {
                return comment
            }
        }
        return nil
    }
    
    // Invite a user
    func invite(user: User, otherUser: User) {
        let invite = Invite(fromId: user.key, fromName: user.displayName(), eventTitle: self.title)
        if let ref = otherUser.ref {
            ref.child("eventInvites").child(self.key).updateChildValues(invite.toAnyObject() as! [AnyHashable : Any])
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
        // Update vote in eventLikes
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
                    // reset userRating
                    if changingVote {
                        self.userRating = !vote
                    } else {
                        self.userRating = nil
                    }
                    
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
            Utils.setRating(rating: userRating, upButton: upButton, downButton: downButton)
        } else {
            let WTM = WTMSingleton.instance
            WTM.dbRef.child("eventLikes").child(key).child(user).observeSingleEvent(of: .value, with: { (snapshot) in
                if let rating = snapshot.value as? Bool {
                    self.userRating = rating
                    Utils.setRating(rating: rating, upButton: upButton, downButton: downButton)
                }
            })
        }
    }
    
    // Check the user into event, does not check if the event is occuring
    func checkin(_ user: User, completionHandler: (() -> Void)? = nil) {
        
        let removingCheckedIn = user.isAttending(self)
        
        // Validate ref and update # of users interested
        if let ref = self.ref {
            ref.child("checkedIn").runTransactionBlock({ (checkedInValue) -> FIRTransactionResult in
                if let newCheckedIn = checkedInValue.value as? Int {
                    if removingCheckedIn {
                        checkedInValue.value = newCheckedIn - 1
                        
                        // Prevent going below 0 for interested
                        if let value = checkedInValue.value as? Int {
                            if value < 0 {
                                checkedInValue.value = 0
                            }
                        }
                    } else {
                        checkedInValue.value = newCheckedIn + 1
                    }
                    return FIRTransactionResult.success(withValue: checkedInValue)
                } else {
                    return FIRTransactionResult.success(withValue: checkedInValue)
                }
            }, andCompletionBlock: { (error, completion, snap) in
                if let error = error {
                    print(error.localizedDescription)
                }
                if !completion {
                    print("Not completed")
                } else if let snap = snap {
                    // FUTURE: Possibly include user name for performance increase(less connections to database)
                    
                    if !removingCheckedIn {
                        user.attend(self)
                    } else {
                        user.unattend(self)
                    }
                    
                    // Update rating for event object
                    if let checkedInValue = snap.value as? Int {
                        self.checkedIn = checkedInValue
                        completionHandler?()
                    }
                }
            })
        }
        
    }

    
    // Check the user into event
    func interest(_ user: User, completionHandler: (() -> Void)? = nil) {
        let removingInterest = user.isInterested(self)
        
        // Validate ref and update # of users interested
        if let ref = self.ref {
            ref.child("interested").runTransactionBlock({ (interestedValue) -> FIRTransactionResult in
                if let newInterested = interestedValue.value as? Int {
                    if removingInterest {
                        interestedValue.value = newInterested - 1
                        
                        // Prevent going below 0 for interested
                        if let value = interestedValue.value as? Int {
                            if value < 0 {
                                interestedValue.value = 0
                            }
                        }
                    } else {
                        interestedValue.value = newInterested + 1
                    }
                    return FIRTransactionResult.success(withValue: interestedValue)
                } else {
                    return FIRTransactionResult.success(withValue: interestedValue)
                }
            }, andCompletionBlock: { (error, completion, snap) in
                if let error = error {
                    print(error.localizedDescription)
                }
                if !completion {
                    print("Not completed")
                } else if let snap = snap {
                    // FUTURE: Possibly include user name for performance increase(less connections to database)
                    
                    if !removingInterest {
                        user.interest(self)
                    } else {
                        user.removeInterest(self)
                    }
                    
                    // Update rating for event object
                    if let interestedValue = snap.value as? Int {
                        self.interested = interestedValue
                        completionHandler?()
                    }
                }
            })
        }
        
    }
    
    // If the event is occuring or not
    func isOccuring() -> Bool {
        let date: Date = Date()
        return date > startDate && date < endDate
    }
    
    // If the event is going to occur in the future
    func willOccur() -> Bool {
        let date: Date = Date()
        return date < startDate
    }
    
    func hasOccurred() -> Bool {
        let date: Date = Date()
        return date > endDate
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
