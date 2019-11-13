//
//  JellyViews.swift
//  MapView
//
//  Created by Elina Lua Ming on 10/3/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import MapKit
import WSTagsField

class JellyMarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            // 1
//            guard let jelly = newValue as? Jelly else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            // 2
//            markerTintColor = jelly.markerTintColor
        }
    }
}

class JellyView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let jelly = newValue as? Jelly else {return}
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,size: CGSize(width: 30, height: 30)))
            mapsButton.setBackgroundImage(UIImage(named: "Maps-Icon"), for: UIControl.State())
            rightCalloutAccessoryView = mapsButton
            
            if let imageName = jelly.emojiImage {
                image = imageName
            } else {
                image = nil
            }
            
            let Tags = jelly.tags
            var allTags: [String] = []
            
            for Tag in Tags {
                allTags.append(Tag.name)
            }
            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.text = jelly.eventDescription
            detailCalloutAccessoryView = detailLabel
            
//            let callOutView = UIView()
//            callOutView.backgroundColor = .red
//            let tagView = WSTagsField()
//            tagView.addTags(allTags)
//            callOutView.addSubview(tagView)
//            detailCalloutAccessoryView = callOutView
            
        }
    }
}
