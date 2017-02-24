//
//  User.swift
//  WhatsTheMove
//
//  Created by Tyler Encke on 9/27/16.
//  Copyright © 2016 WhatsTheMove. All rights reserved.
//

import UIKit
import Firebase

class User: NSObject {
    
    var ref: FIRDatabaseReference?
    
    var key: String = ""
    
    var attendedEventsKeys: [String] = []
    var attendedEvents: [Event] = []
    var bio: String = ""
    var createdEventsKeys: [String] = []
    var createdEvents: [Event] = []
    var email: String = ""
    var friendsKeys: [String] = []
    var friends: [User] = []
    var image: String = ""
    var interested: [Event] = []
    var name: String = ""
    var privacyLevel: Int = 0
    var username: String = ""
    
    public override init() {
        super.init()
    }
    
    public init(snapshot: FIRDataSnapshot) {
        
        ref = snapshot.ref
        
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        key = snapshot.key
        
        if let bioValue = snapshotValue["bio"] as? String {
            bio = bioValue
        }
        
        if let imageValue = snapshotValue["image"] as? String {
            image = imageValue
        }
        
        if let nameValue = snapshotValue["name"] as? String {
            name = nameValue
        }
        
        if let privacyValue = snapshotValue["privacyLevel"] as? Int {
            privacyLevel = privacyValue
        }
        
        if let usernameValue = snapshotValue["username"] as? String {
            username = usernameValue
        }
    }
    
    public func displayName() -> String {
        switch privacyLevel {
        case 0:
            return name
        case 1:
            return username
        case 2:
            return username
        default:
            return username
        }
    }
    
    public func add(newEvent: Event) {
        if let ref = ref {
            // TODO: Transaction block
        }
    }

    func toAnyObject() -> [AnyHashable: Any] {
        return [
            "bio": bio,
            "email": email,
            "image": image,
            "privacyLevel": privacyLevel,
            "username": username
        ]
    }
    
    func toJSONString() -> String {
        return "[" +
            "\n\"bio\": \(bio)," +
            "\n\"email\": \(email)," +
            "\n\"image\": \(image)," +
            "\n\"privacyLevel\": \(privacyLevel)," +
            "\n\"username\": \(username)," +
        "\n]"
    }
    
}
