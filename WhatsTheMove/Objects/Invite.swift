//
//  Invite.swift
//  WhatsTheMove
//
//  Created by Tyler Encke on 2/11/17.
//  Copyright © 2017 WhatsTheMove. All rights reserved.
//

import UIKit

class Invite: NSObject {
    
    var eventId: String = ""
    var eventTitle: String = ""
    var fromId: String = ""
    var fromName: String = ""
    
    init(fromId: String, fromName: String, eventTitle: String) {
        self.fromId = fromId
        self.fromName = fromName
        self.eventTitle = eventTitle
    }
    
    public init(snapshot: [String: Any], eventId: String) {
        super.init()
        
        self.eventId = eventId
        
        if let fromIdValue = snapshot["fromId"] as? String {
            fromId = fromIdValue
        }
        
        if let fromNameValue = snapshot["fromName"] as? String {
            fromName = fromNameValue
        }
        
        if let eventTitleValue = snapshot["eventTitle"] as? String {
            eventTitle = eventTitleValue
        }
    }
    
    func inviteMessage() -> String {
        return fromName + " has invited you to " + eventTitle
    }
    
    func toAnyObject() -> Any {
        return [
            "fromId": fromId,
            "fromName": fromName,
            "eventTitle": eventTitle,
        ]
    }
    
    func toJSONString() -> String {
        return "[" +
            "\n\"fromId\": \(fromId)," +
            "\n\"fromName\": \(fromName)," +
            "\n\"eventTitle\": \(eventTitle)" +
        "\n]"
    }
}
