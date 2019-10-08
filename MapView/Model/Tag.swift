//
//  Tag.swift
//  MapView
//
//  Created by Elina Lua Ming on 10/8/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import Foundation

class Tag {
    
    var tagDictionary: [String : Bool] = [:]
    
    init(tags: [String]) {
        for i in 0..<tags.count {
            tagDictionary[tags[i]] = false
        }
    }
}
