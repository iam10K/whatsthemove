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
    
    private override init() {
        super.init()
        FIRApp.configure()
        
        dbRef = FIRDatabase.database().reference()
        auth = FIRAuth.auth()
    }

    
}
