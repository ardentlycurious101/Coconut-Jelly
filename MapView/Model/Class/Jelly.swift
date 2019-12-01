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
    let emojiImage: UIImage?
    let title: String?
    let tags: [Tag]
    var tagNames: [String] = []
    let eventDescription: String
    
    let startTime: Date
    let endTime: Date
    
    let coordinate: CLLocationCoordinate2D
    var images: [UIImage] // images can be added asynchronously later 
    
    let creatorName : String
    
    init(emoji: String, title: String, tag: [String], eventDescription: String, coordinate: CLLocationCoordinate2D) {

        self.emoji = emoji
        self.emojiImage = emoji.image()
        self.title = title
        self.tags = createTagArray(tag)
        tagNames = getTagNames(tags: tags)
        self.eventDescription = eventDescription

        self.startTime = Date()
        self.endTime = Date()

        self.coordinate = coordinate
        self.images = []

        self.creatorName = ""

        super.init()

    }
    
    init(for jellies: Jellies) {
        
        self.emoji = jellies.emoji!
        self.emojiImage = jellies.emoji!.image()
        self.title = jellies.title!
        self.tags = createTagArray(jellies.tags!.tags)
        tagNames = getTagNames(tags: self.tags)
        self.eventDescription = jellies.jellyDescription!
                
        self.startTime = jellies.startTime!
        self.endTime = jellies.endTime!

        self.coordinate = CLLocationCoordinate2DMake(jellies.latitude, jellies.longitude)
        
        if let images = jellies.images {
            self.images = images.map({ (data) -> UIImage in
                let image = UIImage(data: data)!
                return image
            })
        } else {
            self.images = []
        }

        self.creatorName = jellies.creatorName!
                
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
