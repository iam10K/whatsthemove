//
//  Comment.swift
//  WhatsTheMove
//
//  Created by Tyler Encke on 9/27/16.
//  Copyright © 2016 WhatsTheMove. All rights reserved.
//

import UIKit
import Firebase

class Comment: NSObject {
    
    var ref: FIRDatabaseReference?
    
    var key: String = ""
    
    var createdDate: Date = Date()
    var creatorId: String = ""
    var displayName: String = ""
    var image: String = ""
    var rating: Int = 0
    var text: String = ""
    
    var userRating: Bool?
    
    public override init() {
        super.init()
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
        
        if let displayNameValue = snapshotValue["displayName"] as? String {
            displayName = displayNameValue
        }
        
        if let imageValue = snapshotValue["image"] as? String {
            image = imageValue
        }
        
        if let ratingValue = snapshotValue["rating"] as? Int {
            rating = ratingValue
        }
        
        if let textValue = snapshotValue["text"] as? String {
            text = textValue
        }
    }
    
    public init(key: String, comment: String, user: User) {
        self.key = key
        text = comment
        creatorId = user.key
        displayName = user.displayName()
        image = user.image
    }
    
    // Set the users rating of event
    func rateComment(ofUser user: String, vote: Bool, ratingLabel: UILabel? = nil, completionHandler: (() -> Void)? = nil) {
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
        WTM.dbRef.child("commentLikes").child(key).child(user).setValue(vote)
        
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
                        // If ratingLabel is specified update the label
                        if let ratingLabel = ratingLabel {
                            ratingLabel.text = String(self.rating)
                        }
                        completionHandler?()
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
            WTM.dbRef.child("commentLikes").child(key).child(user).observeSingleEvent(of: .value, with: { (snapshot) in
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
            Utils.changeTint(forButton: upButton, toColor: UIColor.green, withImage: #imageLiteral(resourceName: "arrow-up"))
            Utils.changeTint(forButton: downButton, toColor: nil, withImage: #imageLiteral(resourceName: "arrow-down"))
        } else {
            Utils.changeTint(forButton: upButton, toColor: nil, withImage: #imageLiteral(resourceName: "arrow-up"))
            Utils.changeTint(forButton: downButton, toColor: UIColor.green, withImage: #imageLiteral(resourceName: "arrow-down"))
        }
    }
    
    func toAnyObject() -> [AnyHashable: Any] {
        return [
            "createdDate": createdDate.timeIntervalSince1970,
            "creatorId": creatorId,
            "displayName": displayName,
            "image": image,
            "rating": rating,
            "text": text
        ]
    }
    
    func toJSONString() -> String {
        return "[" +
            "\n\"createdDate\": \(createdDate.timeIntervalSince1970)," +
            "\n\"creatorId\": \(creatorId)," +
            "\n\"displayName\": \(displayName)," +
            "\n\"image\": \(image)," +
            "\n\"rating\": \(rating)," +
            "\n\"text\": \(text)" +
        "\n]"
    }
    
}
