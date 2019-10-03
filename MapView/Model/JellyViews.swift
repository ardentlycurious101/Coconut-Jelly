//
//  JellyViews.swift
//  MapView
//
//  Created by Elina Lua Ming on 10/3/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import MapKit

class JellyMarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            // 1
            guard let jelly = newValue as? Jelly else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            // 2
            markerTintColor = jelly.markerTintColor
        }
    }
}

class JellyView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let jelly = newValue as? Jelly else {return}
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            if let imageName = jelly.emojiImage {
                image = imageName
            } else {
                image = nil
            }
        }
    }
}
