//
//  EventLocation.swift
//  WhatsTheMove
//
//  Created by Tyler Encke on 11/27/16.
//  Copyright © 2016 WhatsTheMove. All rights reserved.
//

import UIKit

class EventLocation: NSObject {
    
    var address: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var addressName: String = ""
    
    public override init() {
        super.init()
    }
    
    public init(values: [String: AnyObject]) {
        
        if let addressValue = values["address"] as? String {
            address = addressValue
        }
        
        if let latitudeValue = values["latitude"] as? Double {
            latitude = latitudeValue
        }
        
        if let longitudeValue = values["longitude"] as? Double {
            longitude = longitudeValue
        }
        
        if let addressNameValue = values["addressName"] as? String {
            addressName = addressNameValue
        }
    }
    
    public func toAnyObject() -> Any {
        return [
            "address": address,
            "longitude": longitude,
            "latitude": latitude,
            "addressName": addressName
        ]
    }
    
    public func toJSONString() -> String {
        return "[" +
            "\n\"address\": \(address)," +
            "\n\"longitude\": \(longitude)," +
            "\n\"latitude\": \(latitude)," +
            "\n\"addressName\": \(addressName)" +
        "\n]"
    }
}
