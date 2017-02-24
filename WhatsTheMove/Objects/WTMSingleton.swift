//
//  WTMSingleton.swift
//  WhatsTheMove
//
//  Created by Tyler Encke on 10/27/16.
//  Copyright © 2016 WhatsTheMove. All rights reserved.
//

import UIKit
import Firebase

class WTMSingleton: NSObject {
    
    static let instance = WTMSingleton()
    
    var dbRef: FIRDatabaseReference!
    var auth: FIRAuth!
    
    var newEvent: Event = Event()
    
    var user: User?
    
    var eventsObservable: Observable<[Event]>
    
    private override init() {
        eventsObservable = Observable<[Event]>(initialValue: Array<Event>())
        
        super.init()
        
        
        FIRApp.configure()
        
        dbRef = FIRDatabase.database().reference()
        auth = FIRAuth.auth()
        
        auth.addStateDidChangeListener({ (auth, firUser) in
            if let firUser = firUser {
                // Load User
                self.loadUser(currentUser: firUser) {
                    // Load Events
                    self.reloadEvents()
                }
            } else {
                // Clear events and user data, since user logged out
                self.clearData()
            }
        })
    }
    
    func reloadEvents() {
        // Listen for new events
        dbRef.child("events").observe(.value, with: { snapshot in
            var newEvents: [Event] = []
            
            // TODO: Filter events
            // Add all events from database
            for event in snapshot.children {
                // 4
                let eventObject = Event(snapshot: event as! FIRDataSnapshot)
                newEvents.append(eventObject)
            }
            
            // Set list to temporary list created
            self.eventsObservable.observableProperty = newEvents
        })
    }
    
    func loadUser(currentUser: FIRUser, completion: (() -> Void)? = nil) {
        // Listen for user changes
        dbRef.child("users").child(currentUser.uid).observe(.value, with: { snapshot in
            if snapshot.exists() {
                self.user = User(snapshot: snapshot)
            }
            if let completion = completion {
                completion()
            }
        })
    }
    
    // Clears the user and events from the singleton
    func clearData() {
        self.eventsObservable.observableProperty = []
        self.user = nil
    }
    
    // Validate user has set their username in the DB
    func userExists(of uid: String, completion: @escaping (Bool) -> Void) {
        self.dbRef.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(uid) {
                // User exists in DB
                completion(true)
            } else {
                // User is not in DB
                completion(false)
            }
            
        }) { (error) in
            print(error.localizedDescription)
            completion(false)
        }
        
    }
}
