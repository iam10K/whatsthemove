//
//  Event.swift
//  WhatsTheMove
//
//  Created by Tyler Encke on 9/27/16.
//  Copyright © 2016 WhatsTheMove. All rights reserved.
//

import UIKit

class Event: NSObject {
    
    var eventDescription: String = ""
    var endDate: Date = Date()
    var ended: String = ""
    var entryNote: String = ""
    var address: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var name: String = ""
    var privacyLevel: Int = 0
    var sponsor: String = ""
    var startDate: Date = Date()
    var title: String = ""
}
