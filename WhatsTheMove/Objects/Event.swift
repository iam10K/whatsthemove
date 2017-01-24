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
    
    var createdDate: Date = Date()
    var creatorId: String = ""
    var endDate: Date = Date()
    var ended: Bool = false
    var entryNote: String = ""
    var eventDescription: String = ""
    var friendsCanInvite: Bool = true
    var location: EventLocation = EventLocation()
    var privacyLevel: Int = 0
    var rating: Int = 0
    var userRating: Bool?
    var sponsor: String = ""
    var startDate: Date = Date()
    var title: String = ""
    
    public override init() {
        super.init()
        
        endDate = createDate()
        startDate = createDate()
    }
    
    public init(snapshot: FIRDataSnapshot) {
        
        ref = snapshot.ref
        
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        key = snapshot.key
        
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
    }
    
    func clear() {
        creatorId = ""
        ended = false
        endDate = createDate()
        entryNote = ""
        eventDescription = ""
        location = EventLocation()
        friendsCanInvite = true
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
    
    // Set the users rating of event
    func rateEvent(ofUser user: String, vote: Bool, ratingLabel: UILabel? = nil) {
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
                    print("Completed")
                } else if let snap = snap {
                    // Update rating for event object
                    if let ratingValue = snap.value as? Int {
                        self.rating = ratingValue
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
    
    func toAnyObject() -> [AnyHashable: Any] {
        return [
            "createdDate": createdDate.timeIntervalSince1970,
            "creatorId": creatorId,
            "description": eventDescription,
            "endDate": endDate.timeIntervalSince1970,
            "ended": ended ? 1 : 0,
            "entryNote": entryNote,
            "friendsCanInvite": friendsCanInvite ? 1 : 0,
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
            "\n\"createdDate\": \(createdDate.timeIntervalSince1970)," +
            "\n\"creatorId\": \(creatorId)," +
            "\n\"description\": \(eventDescription)," +
            "\n\"endDate\": \(endDate.timeIntervalSince1970)," +
            "\n\"ended\": \(ended)," +
            "\n\"entryNote\": \(entryNote)," +
            "\n\"friendsCanInvite\": \(friendsCanInvite ? 1 : 0)," +
            "\n\"location\": \(location.toJSONString())," +
            "\n\"privacyLevel\": \(privacyLevel)," +
            "\n\"rating\": \(rating)," +
            "\n\"sponsor\": \(sponsor)," +
            "\n\"startDate\": \(startDate.timeIntervalSince1970)," +
            "\n\"title\": \(title)" +
        "\n]"
    }
}
