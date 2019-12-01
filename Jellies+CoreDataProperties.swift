//
//  Jellies+CoreDataProperties.swift
//  
//
//  Created by Elina Lua Ming on 11/30/19.
//
//

import Foundation
import CoreData


extension Jellies {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Jellies> {
        return NSFetchRequest<Jellies>(entityName: "Jellies")
    }

    @NSManaged public var creatorName: String?
    @NSManaged public var emoji: String?
    @NSManaged public var endTime: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var images: [Data]?
    @NSManaged public var jellyDescription: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var startTime: Date?
    @NSManaged public var tags: JelliesTags?
    @NSManaged public var title: String?

}
