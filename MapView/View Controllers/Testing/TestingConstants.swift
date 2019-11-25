//
//  TestingConstants.swift
//  MapView
//
//  Created by Elina Lua Ming on 10/2/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import MapKit

// For updating Cloud Firestore, and render event on map
let jellyArray : [Jelly] = [jelly, brian, nabila, yasmin, abbas, foxxy, jose, izzat]

// For SearchTagsViewController
var existingTags = Array(Set(jellyArray.flatMap { return $0.tagNames})).sorted(by: { $0 < $1 })

var existingTagDictionary = returnTagDictionary(for: existingTags)

// MARK:- Create dictionary of tags with unchecked default values
func returnTagDictionary(for tags: [String]) -> [String : Bool] {
    var dictionary : [String : Bool] = [:]
    
    for tag in tags {
        dictionary[tag] = false
    }
    
    return dictionary
}

// For View Controller displaying map
var existingEmojis = Array(Set(jellyArray.flatMap { return $0.emoji }))
