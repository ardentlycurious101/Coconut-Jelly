//
//  Tag.swift
//  MapView
//
//  Created by Elina Lua Ming on 10/8/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import Foundation

class Tag {
    
    var name: String
    var checked: Bool
    
    init(tag: String) {
        self.name = tag
        self.checked = false
    }
}

func createTagArray(_ tags: [String]) -> [Tag] {
    
    var tagArray  = [Tag]()
    
    for tag in tags {
        tagArray.append(Tag(tag: tag))
    }
    
    return tagArray
}


func getTagNames(tags: [Tag]) -> [String] {
    var array: [String] = []
    for tag in tags {
        array.append(tag.name)
    }
    return array
}


