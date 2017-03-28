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
    var sentRequestKeys: [String] = []
    var receivedRequestKeys: [String] = []
    var receivedRequestUsers: [User] = []
    //var blockedUsers: [String] = []
    var createdEventsKeys: [String] = []
    var createdEvents: [Event] = []
    var email: String = ""
    var friendsKeys: [String] = []
    var friends: [User] = []
    var image: String = ""
    var interestedKeys: [String] = []
    var interested: [Event] = []
    var invitedEvents: [Invite] = []
    var name: String = ""
    var privacyLevel: Int = 0
    var username: String = ""
    
    public override init() {
        super.init()
    }
    
    public init(snapshot: FIRDataSnapshot) {
        super.init()
        
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
        
        //if let eventInvitesValue = snapshotValue["eventInvites"] as? [AnyHashable: Any] {
        // Add all keys to the string list
        // FUTURE:
        //}
        
        if let attendedEventsValue = snapshotValue["attendedEvents"] as? [String: AnyObject] {
            // Add all keys to the string list
            attendedEventsKeys.append(contentsOf: Array(attendedEventsValue.keys))
            
        }
        
        if let createdEventsValue = snapshotValue["createdEvents"] as? [String: AnyObject] {
            // Add all keys to the string list
            createdEventsKeys.append(contentsOf: Array(createdEventsValue.keys))
            
        }
        
    }
    
    public convenience init(selfSnapshot: FIRDataSnapshot) {
        self.init(snapshot: selfSnapshot)
        
        let snapshotValue = selfSnapshot.value as! [String: AnyObject]
        
        if let interestedEventsValue = snapshotValue["interestedEvents"] as? [String: Bool] {
            for (eventId,value) in interestedEventsValue {
                if value {
                    selfSnapshot.ref.database.reference().child("events").child(eventId).observe(.value, with: { snapshot in
                        if snapshot.exists() {
                            let event = Event(snapshot: snapshot)
                            self.interested.append(event)
                            self.interestedKeys.append(event.key)
                        }
                        
                    })
                }
            }
        }
        
        if let invitesValue = snapshotValue["eventInvites"] as? [String: AnyObject] {
            for (eventId,value) in invitesValue {
                let invite = Invite(snapshot: value as! [String : Any], eventId: eventId)
                self.invitedEvents.append(invite)
            }
        }
        
        if let friendsValue = snapshotValue["friends"] as? [String: Bool] {
            // Add all keys to the string list
            for (friendId,value) in friendsValue {
                if value {
                    self.friendsKeys.append(friendId)
                    
                    // Observe the user once
                    selfSnapshot.ref.database.reference().child("users").child(friendId).observeSingleEvent(of: .value, with: { snapshot in
                        if snapshot.exists() {
                            let friend = User(snapshot: snapshot)
                            self.friends.append(friend)
                        }
                    })
                } else {
                    // FUTURE: Maybe use false for blocked users
                }
            }
        }
        
        if let friendRequestValue = snapshotValue["friendRequests"] as? [String: Bool] {
            for (friendId,value) in friendRequestValue {
                if value {
                    // if user sent request to user
                    if !self.sentRequestKeys.contains(friendId) {
                        self.sentRequestKeys.append(friendId)
                    }
                } else {
                    // if user is getting a request
                    if !self.receivedRequestKeys.contains(friendId) {
                        self.receivedRequestKeys.append(friendId)
                        // Observe the user once
                        selfSnapshot.ref.database.reference().child("users").child(friendId).observeSingleEvent(of: .value, with: { snapshot in
                            if snapshot.exists() {
                                let friend = User(snapshot: snapshot)
                                self.receivedRequestUsers.append(friend)
                            }
                        })
                    }
                }
            }
        }
        
        // Load attended and created for user
        loadCreatedEvents()
        loadAttendedEvents()
    }
    
    public convenience init(friendSnapshot: FIRDataSnapshot) {
        self.init(snapshot: friendSnapshot)
        
        let snapshotValue = friendSnapshot.value as! [String: AnyObject]
        
        if let friendsValue = snapshotValue["friends"] as? [String: Bool] {
            // Add all keys to the string list
            for (friendId,value) in friendsValue {
                if value {
                    self.friendsKeys.append(friendId)
                }
            }
        }
    }
    
    // TODO FUTURE: BUG Solution: Fix so all events are loaded from WTM events
    
    func loadAttendedEvents(completion: (() -> Void)? = nil) {
        attendedEvents = []
        if let ref = ref {
            for eventId in attendedEventsKeys {
                ref.database.reference().child("events").child(eventId).observeSingleEvent(of: .value, with: { snapshot in
                    if snapshot.exists() {
                        let event = Event(snapshot: snapshot)
                        self.attendedEvents.append(event)
                        
                        if let last = self.attendedEventsKeys.last {
                            if last == eventId {
                                completion?()
                            }
                        }
                    }
                })
            }
        }
    }
    
    func loadCreatedEvents(completion: (() -> Void)? = nil) {
        createdEvents = []
        if let ref = ref {
            for eventId in createdEventsKeys {
                ref.database.reference().child("events").child(eventId).observeSingleEvent(of: .value, with: { snapshot in
                    if snapshot.exists() {
                        let event = Event(snapshot: snapshot)
                        self.createdEvents.append(event)
                        
                        if let last = self.createdEventsKeys.last {
                            if last == eventId {
                                completion?()
                            }
                        }
                    }
                })
            }
        }
    }
    
    // ???maybe make work w/ passed in user
    func displayName() -> String {
        switch privacyLevel {
        case 0:
            return name
        case 1:
            return username
        default:
            return username
        }
    }
    
    //displays message with the name of a use rwho wants to be friends
    func requestMessage() -> String {
        return displayName() + " wants to be friends"
    }
    
    func isInterested(_ event: Event) -> Bool {
        return self.interestedKeys.contains(event.key)
    }
    
    func isAttending(_ event: Event) -> Bool {
        return self.attendedEventsKeys.contains(event.key)
    }
    
    func create(_ event: Event) {
        // Add created lists
        self.createdEvents.append(event)
        self.createdEventsKeys.append(event.key)
        if let ref = ref {
            // Add to firebase
            ref.child("createdEvents").updateChildValues([event.key:true]) { error,_ in
                if error != nil {
                    // Remove event from created since error occured
                    if let index = self.createdEvents.index(of: event) {
                        self.createdEvents.remove(at: index)
                    }
                    // Remove event from created keys
                    if let index = self.createdEventsKeys.index(of: event.key) {
                        self.createdEventsKeys.remove(at: index)
                    }
                    print(error!)
                }
            }
        }
    }
    
    func removeCreated(_ event: Event) {
        // Remove event from created
        if let index = self.createdEvents.index(of: event) {
            self.createdEvents.remove(at: index)
        }
        // Remove event from created keys
        if let index = self.createdEventsKeys.index(of: event.key) {
            self.createdEventsKeys.remove(at: index)
        }
        if let ref = ref {
            // Remove from firebase
            ref.child("createdEvents").child(event.key).removeValue() { error,_ in
                if error == nil {
                    // Add back to created lists because error occured
                    self.createdEvents.append(event)
                    self.createdEventsKeys.append(event.key)
                    print(error!)
                }
            }
        }
    }
    
    func interest(_ event: Event) {
        // Add to interested array
        self.interested.append(event)
        self.interestedKeys.append(event.key)
        if let ref = ref {
            // Add to firebase
            ref.child("interestedEvents").updateChildValues([event.key:true]) { error,_ in
                if error != nil {
                    // Remove from array since error occured
                    if let index = self.interested.index(of: event) {
                        self.interested.remove(at: index)
                    }
                    if let index = self.interestedKeys.index(of: event.key) {
                        self.interestedKeys.remove(at: index)
                    }
                    print(error!)
                } else {
                    // Add interested for event
                    let dbRef = ref.database.reference()
                    dbRef.child("interested").child(event.key).child(self.key).setValue(true)
                }
            }
        }
    }
    
    func removeInterest(_ event: Event) {
        // Remove from interested array
        if let index = self.interested.index(of: event) {
            self.interested.remove(at: index)
        }
        if let index = self.interestedKeys.index(of: event.key) {
            self.interestedKeys.remove(at: index)
        }
        if let ref = ref {
            // Remove interest from user firebase
            ref.child("interestedEvents").child(event.key).removeValue() { error,_ in
                if error != nil {
                    // Add back because error occured
                    self.interested.append(event)
                    self.interestedKeys.append(event.key)
                    print(error!)
                } else {
                    // Remove interested for event
                    let dbRef = ref.database.reference()
                    dbRef.child("interested").child(event.key).child(self.key).removeValue()
                }
            }
        }
    }
    
    func attend(_ event: Event) {
        // Add to attended array
        self.attendedEvents.append(event)
        self.attendedEventsKeys.append(event.key)
        if let ref = ref {
            // Add to firebase for user
            ref.child("attendedEvents").updateChildValues([event.key:true]) { error,_ in
                if error != nil {
                    // Remove since error occured
                    if let index = self.attendedEvents.index(of: event) {
                        self.attendedEvents.remove(at: index)
                    }
                    if let index = self.attendedEventsKeys.index(of: event.key) {
                        self.attendedEventsKeys.remove(at: index)
                    }
                    print(error!)
                } else {
                    // FUTURE: Check if user is near location, task for later
                    // FUTURE: Possibly include user name for performance increase(less connections to database)
                    let dbRef = ref.database.reference()
                    dbRef.child("checkedIn").child(event.key).child(self.key).setValue(
                        ["date": Date().timeIntervalSince1970,
                         "atLocation": false])
                }
            }
        }
    }
    
    func sendFriendRequest(_ otherUser: User) {
        if self.sentRequestKeys.contains(otherUser.key) {
            return
        }
        
        // Add friend to list sent requests
        self.sentRequestKeys.append(otherUser.key)
        if let ref = ref {
            // Add to firebase for user
            ref.child("friendRequests").updateChildValues([otherUser.key:true]) { error,_ in
                if let error = error {
                    // Remove since error occured
                    if let index = self.sentRequestKeys.index(of: otherUser.key) {
                        self.sentRequestKeys.remove(at: index)
                    }
                    print(error)
                } else {
                    // Add friend for other user
                    otherUser.receiveFriendRequest(self)
                }
            }
        }
    }
    
    func receiveFriendRequest(_ otherUser: User) {
        if self.receivedRequestKeys.contains(otherUser.key) {
            return
        }
        
        // Add friend to list received requests
        self.receivedRequestKeys.append(otherUser.key)
        if let ref = ref {
            // Add to firebase for user
            ref.child("friendRequests").updateChildValues([otherUser.key:false]) { error,_ in
                if let error = error {
                    // Remove since error occured
                    if let index = self.receivedRequestKeys.index(of: otherUser.key) {
                        self.receivedRequestKeys.remove(at: index)
                    }
                    print(error)
                }
            }
        }
    }
    
    func removeFriendRequest(_ otherUser: User) {
        // remove from requests lists
        if let index = self.sentRequestKeys.index(of: otherUser.key) {
            self.sentRequestKeys.remove(at: index)
        }
        
        if let index = self.receivedRequestKeys.index(of: otherUser.key) {
            self.receivedRequestKeys.remove(at: index)
        }
        
        // remove requests from each user
        if let ref = ref {
            // Add to firebase for user
            ref.child("friendRequests").child(otherUser.key).removeValue()
        }
        
        if let ref = otherUser.ref {
            // Add to firebase for user
            ref.child("friendRequests").child(self.key).removeValue()
        }
    }
    
    func addFriend(_ friend: User) {
        if !self.receivedRequest(friend.key) {
            return
        }
        
        if self.friendsKeys.contains(friend.key) {
            return
        }
        
        // Add friend to list
        self.friends.append(friend)
        self.friendsKeys.append(friend.key)
        if let ref = ref {
            // Add to firebase for user
            ref.child("friends").updateChildValues([friend.key:true]) { error,_ in
                if let error = error {
                    // Remove since error occured
                    if let index = self.friends.index(of: friend) {
                        self.friends.remove(at: index)
                    }
                    if let index = self.friendsKeys.index(of: friend.key) {
                        self.friendsKeys.remove(at: index)
                    }
                    print(error)
                } else {
                    // Add friend for other user
                    friend.addFriend(self)
                }
            }
        }
    }
    
    func removeFriend(_ friend: User) {
        if !self.friendsKeys.contains(friend.key) {
            return
        }
        
        // Remove friend
        if let index = self.friends.index(of: friend) {
            self.friends.remove(at: index)
        }
        if let index = self.friendsKeys.index(of: friend.key) {
            self.friendsKeys.remove(at: index)
        }
        if let ref = ref {
            // Add to firebase for user
            ref.child("friends").child(friend.key).removeValue()
            friend.removeFriend(self)
        }
    }
    
    func areFriends(_ userId: String) -> Bool {
        return friendsKeys.contains(userId)
    }
    
    // sent friendrequest to userId
    func sentRequest(_ userId: String) -> Bool {
        return sentRequestKeys.contains(userId)
    }
    
    // if friend request received from the userId
    func receivedRequest(_ userId: String) -> Bool {
        return receivedRequestKeys.contains(userId)
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
