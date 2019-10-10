//
//  TestingConstants.swift
//  MapView
//
//  Created by Elina Lua Ming on 10/2/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import MapKit

// MARK:- Testing Constants

// set initial location in Honolulu
let initialLocation = CLLocation(latitude: 34.071282, longitude: -118.445001)

let regionRadius: CLLocationDistance = 750


let jellyArray : [Jelly] = [jelly, brian, nabila, yasmin, abbas, foxxy, jose, izzat]

var existingTags = Array(Set(jellyArray.flatMap { return $0.tagNames})).sorted(by: { $0 < $1 })

var existingTagDictionary = returnTagDictionary(for: existingTags)

var existingEmojis = Array(Set(jellyArray.flatMap { return $0.emoji }))

// MARK:- Create dictionary of tags with unchecked default values

func returnTagDictionary(for tags: [String]) -> [String : Bool] {
    var dictionary : [String : Bool] = [:]
    
    for tag in tags {
        dictionary[tag] = false
    }
    
    return dictionary
}

// MARK:-
func displayCheckedTags(for existingTagDictionary: [String : Bool]) {
    
}
