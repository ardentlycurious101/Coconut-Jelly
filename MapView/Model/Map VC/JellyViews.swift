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
            
            // image of annotation view displayed on map
            if let imageName = jelly.emojiImage {
                image = imageName
            } else {
                image = nil
            }
            
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            
            configureDetailCalloutAccessory(for: jelly)
        }
    }
    
    func configureDetailCalloutAccessory(for jelly: Jelly) {
        let tagLabel = PaddingLabel(withInsets: 5, 5, 10, 10)
        tagLabel.numberOfLines = 0
        tagLabel.font = tagLabel.font.withSize(12)
        
        let tags = jelly.combineTags()
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)]
        let attributedString = NSMutableAttributedString(string: tags, attributes:attrs)
        let normalText = NSMutableAttributedString(string: "\n" + jelly.eventDescription)
        attributedString.append(normalText)
        
        tagLabel.attributedText = attributedString
        tagLabel.lineBreakMode = .byWordWrapping
        tagLabel.backgroundColor = UIColor(patternImage: UIImage(named: "gradient")!)
        tagLabel.layer.cornerRadius = 10
        tagLabel.clipsToBounds = true
        detailCalloutAccessoryView = tagLabel
        
        let mapButton = UIButton(frame: CGRect(origin: CGPoint.zero,size: CGSize(width: 40, height: 40)))
        mapButton.setBackgroundImage(UIImage(named: "Maps-Icon"), for: UIControl.State())
        rightCalloutAccessoryView = mapButton
    }

}
