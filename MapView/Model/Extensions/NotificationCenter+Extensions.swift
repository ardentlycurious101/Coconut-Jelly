//
//  NotificationCenter+Extensions.swift
//  MapView
//
//  Created by Elina Lua Ming on 12/1/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    static let newJellyAdded = Notification.Name("newJellyAddedToArray")
    static let filteredJellyAdded = Notification.Name("filteredJellyAddedToArray")
    static let tagAdded = Notification.Name("tagAdded")
//    static let useFilteredJellies = Notification.Name("useFilteredJellies")
    static let useAllJellies = Notification.Name("useAllJellies")
    static let turnOffFilter = Notification.Name("turnOffFilter")
    static let imageSaved = Notification.Name("imageSaved")
    static let checkEmojiName = Notification.Name("checkEmojiName")
    
}
