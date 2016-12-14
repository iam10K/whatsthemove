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
        
        if let sponsorValue = snapshotValue["sponsor"] as? String {
            sponsor = sponsorValue
        }
        
        if let startDateValue = snapshotValue["endDate"] as? Double {
            endDate = Date(timeIntervalSince1970: startDateValue)
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
            "\n\"sponsor\": \(sponsor)," +
            "\n\"startDate\": \(startDate.timeIntervalSince1970)," +
            "\n\"title\": \(title)" +
        "\n]"
    }
}
