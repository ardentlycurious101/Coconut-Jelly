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

let regionRadius: CLLocationDistance = 1000


let jelly = Jelly(emoji: "🌮", title: "Foundations Tacos", tag: ["food", "dance"], eventDescription: "Come support us at our fundraising event!", coordinate: jellyCoordinate)
let pudding = Jelly(emoji: "🏋🏽‍♀️", title: "Barbell Brigade", tag: ["strength", "club sport", "chill people", "fun"], eventDescription: "Come and meet learn how to squat, bench, and deadlift. Oh there'll also be really chill people here!!!", coordinate: puddingCoordinate )
let jellyCoordinate = CLLocationCoordinate2D(latitude: 34.071056, longitude: -118.444349)
let puddingCoordinate = CLLocationCoordinate2D(latitude: 34.071893, longitude: -118.445918)
