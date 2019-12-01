////
////  Jellies+CoreDataClass.swift
////
////
////  Created by Elina Lua Ming on 11/21/19.
////
////
//
//import Foundation
//import UIKit
//import CoreData
//import MapKit
//
//@objc(Jellies)
//public class Jello: NSManagedObject, MKAnnotation {
//    
//    public var subtitle: String? {
//        return combineTags()
//    }
//    
//    func combineTags() -> String {
//        var allTags : String = ""
//        for i in 0..<tags.count {
//            if i < tags.count - 1 {
//                allTags.append(tags[i].name + ", ")
//            }
//            else {
//                allTags.append(tags[i].name)
//            }
//        }
//        return allTags
//    }
//    
//    // Annotation right callout accessory opens this mapItem in Maps app
//    func mapItem() -> MKMapItem {
//        let addressDict = [CNPostalAddressStreetKey: subtitle!]
//        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
//        let mapItem = MKMapItem(placemark: placemark)
//        mapItem.name = title
//        return mapItem
//    }
//     
//}
