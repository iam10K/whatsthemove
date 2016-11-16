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
    var entryNote: String = ""
    var address: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var addressName: String = ""
    var friendsCanInvite: Bool = true
    var privacyLevel: Int = 0
    var sponsor: String = ""
    var startDate: Date = Date()
    var title: String = ""
    
    public override init() {
        super.init()
        
        endDate = createDate()
        startDate = createDate()
    }
    
    func clear() {
        eventDescription = ""
        endDate = createDate()
        entryNote = ""
        address = ""
        latitude = 0.0
        longitude = 0.0
        addressName = ""
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

}
