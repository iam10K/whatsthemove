//
//  Utils.swift
//  WhatsTheMove
//
//  Created by Tyler Encke on 1/17/17.
//  Copyright © 2017 WhatsTheMove. All rights reserved.
//

import Foundation
import MapKit

class Utils: NSObject {
    
    // Formats the date based on how far in future it is.
    // Dates == today will format as Today at h:mm a
    // Dates within 7 days will format EEE at h:mm a
    // In same year will format MMM d at h:mm a
    // Else MMM d, yyyy at h:mm a
    static func format(date: Date) -> String {
        
        // Gather all the date components to construct new date
        let curCalendar = Calendar.current
        let dateComponents = curCalendar.dateComponents([.year, .month, .day], from: Date())
        
        // Create new date from components to remove time
        var futureComponents = DateComponents()
        futureComponents.year = dateComponents.year
        futureComponents.month = dateComponents.month
        futureComponents.day = dateComponents.day
        
        var withinWeekDate = curCalendar.date(from: futureComponents)
        // Add 7 days in seconds
        withinWeekDate?.addTimeInterval(604800)
        
        futureComponents.year = dateComponents.year! + 1
        let nextYearDate = curCalendar.date(from: futureComponents)

        
        // Date formatter
        let formatter = DateFormatter()
        
        if NSCalendar.current.isDateInToday(date) {
            formatter.dateFormat = "\'Today at\' h:mm a"
        } else if withinWeekDate != nil && date.compare(withinWeekDate!) == .orderedAscending {
            formatter.dateFormat = "EEE \'at\' h:mm a"
        } else if nextYearDate != nil && NSCalendar.current.compare(date, to: nextYearDate!, toGranularity: .year) == .orderedAscending {
            formatter.dateFormat = "MMM d \'at\' h:mm a"
        } else {
            formatter.dateFormat = "MMM d, yyyy \'at\' h:mm a"
        }
        
        // Generate string for start and end date
        let dateString = formatter.string(from: date)
        
        return dateString
    }
    
    // Parse address
    static func parseAddress(for selectedItem: MKPlacemark) -> String {
        // Put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // Put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // Put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // Street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // Street name
            selectedItem.thoroughfare ?? "",
            comma,
            // City
            selectedItem.locality ?? "",
            secondSpace,
            // State
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
}
