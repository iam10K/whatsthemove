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
    
    public init(comment: String, user: User) {
        text = comment
        creatorId = user.key
        displayName = user.displayName()
        image = user.image
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
