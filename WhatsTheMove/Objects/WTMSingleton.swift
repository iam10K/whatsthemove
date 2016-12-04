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
    
    var events: [Event]?
    
    private override init() {
        super.init()
        FIRApp.configure()
        
        dbRef = FIRDatabase.database().reference()
        auth = FIRAuth.auth()
        
        reloadEvents()
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
            self.events = newEvents
        })
    }
    
    
}
