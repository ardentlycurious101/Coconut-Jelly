//
//  Jellies+CoreDataClass.swift
//  
//
//  Created by Elina Lua Ming on 11/21/19.
//
//

import Foundation
import CoreData
import MapKit

@objc(Jellies)
public class Jellies: NSManagedObject, MKAnnotation {

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
 
}
