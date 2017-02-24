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
    // Dates within 7 days will format EEEE at h:mm a
    // In same year will format MMM d at h:mm a
    // Else MMM d, yyyy at h:mm a
    static func format(date: Date) -> String {
        
        // Gather all the date components to construct new date
        let curCalendar = Calendar.current
        let dateComponents = curCalendar.dateComponents([.year, .month, .day], from: date)
        
        // Create new date from components to remove time
        var futureComponents = DateComponents()
        futureComponents.year = dateComponents.year
        futureComponents.month = dateComponents.month
        futureComponents.day = dateComponents.day
        
        var withinWeekDate = curCalendar.date(from: futureComponents)
        // Add 7 days in seconds
        withinWeekDate?.addTimeInterval(604800)
        
        // Date formatter
        let formatter = DateFormatter()
        
        if NSCalendar.current.isDateInToday(date) {
            formatter.dateFormat = "\'Today at\' h:mm a"
        } else if withinWeekDate != nil && date.compare(Date()) == .orderedDescending && date.compare(withinWeekDate!) == .orderedAscending {
            formatter.dateFormat = "EEEE \'at\' h:mm a"
        } else if NSCalendar.current.compare(date, to: Date(), toGranularity: .year) == .orderedSame {
            formatter.dateFormat = "MMM d \'at\' h:mm a"
        } else {
            formatter.dateFormat = "MMM d, yyyy \'at\' h:mm a"
        }
        
        // Generate string for start and end date
        let dateString = formatter.string(from: date)
        
        return dateString
    }
    
    // Formats the date based on how far apart they are.
    static func format(startDate: Date, endDate: Date) -> String {
        // TODO: Format the combined dates
        // Not sure on format yet. Maybe if today: Today 6:00PM - 7:00PM
        // If ends on different day: Today 6:00PM - Tuesday 6:00PM
        // If starts and ends on different days not in same week Jan 7 at 6:00PM - Jan 17 at 8:00PM
        // else: Dec 28, 2016 at 6:00PM - Jan 1, 2017 at 2:00PM
        
        // For now just return start date
        return format(date: startDate)
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
    
    // Change the tint and image of a button
    static func changeTint(forButton button: UIButton, toColor color: UIColor? = nil, withImage image: UIImage) {
        var newImage = image.withRenderingMode(.alwaysTemplate)
        if color == nil {
            newImage = image
        }
        button.setImage(newImage, for: .normal)
        button.tintColor = color
    }
}
