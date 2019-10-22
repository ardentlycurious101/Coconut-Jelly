//
//  Event.swift
//  MapView
//
//  Created by Elina Lua Ming on 10/2/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class Jelly: NSObject, MKAnnotation {
    
    let emoji: String
    let title: String?
//    let locationName: String
//    let dateTime: NSDate
    let tags: [Tag]
    var tagNames: [String] = []
    let eventDescription: String
    let coordinate: CLLocationCoordinate2D
    let markerTintColor : UIColor
    let imageName : String?
    let emojiImage : UIImage?
    
    init(emoji: String, title: String, tag: [String], eventDescription: String, coordinate: CLLocationCoordinate2D) {
        self.emoji = emoji
        self.title = title
//        self.dateTime = dateTime
//        self.tag = tag
        self.tags = createTagArray(tag)
        tagNames = getTagNames(tags: tags)
        self.eventDescription = eventDescription
        self.coordinate = coordinate
        self.markerTintColor = .red
        self.imageName = "black bean"
        self.emojiImage = emoji.image()

        super.init()
        
    }
    
    var subtitle: String? {
        return combineTags()
    }
    
    func combineTags() -> String {
        var allTags : String = ""
        for i in 0..<tags.count {
            if i < tags.count - 1 {
                allTags.append(tags[i].name + ", ")
            }
            else {
                allTags.append(tags[i].name)
            }
        }
        return allTags
    }
    
    // Annotation right callout accessory opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }

}
