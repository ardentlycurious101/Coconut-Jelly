//
//  Event.swift
//  MapView
//
//  Created by Elina Lua Ming on 10/2/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import Foundation
import MapKit

class Jelly: NSObject, MKAnnotation {
    
    let eventName: String
    let dateTime: NSDate
    let tag: [String]
    let eventDescription: String
    let coordinate: CLLocationCoordinate2D
    
    init(eventName: String, dateTime: NSDate, tag: [String], eventDescription: String, coordinate: CLLocationCoordinate2D) {
        self.eventName = eventName
        self.dateTime = dateTime
        self.tag = tag
        self.eventDescription = eventDescription
        self.coordinate = coordinate
        
        super.init()
    }
}
