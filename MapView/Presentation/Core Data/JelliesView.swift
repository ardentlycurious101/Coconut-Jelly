//
//  JelliesView.swift
//  MapView
//
//  Created by Elina Lua Ming on 11/29/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import Foundation
import MapKit


class JelliesView: MKAnnotationView {
                
    override var annotation: MKAnnotation? {
        willSet {
            guard let jellies = newValue as? Jellies else { return }
            
            // image of annotation view displayed on map
            if let emoji = jellies.emoji {
                image = emoji.image()
            } else {
                image = nil
            }
            
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            
            configureDetailCalloutAccessory(for: jellies)
        }
    }
    
    func configureDetailCalloutAccessory(for jellies: Jellies) {
        let tagLabel = PaddingLabel(withInsets: 5, 5, 10, 10)
        tagLabel.numberOfLines = 0
        tagLabel.font = tagLabel.font.withSize(12)
        
        let tags = combineTags(jellies.tags!.tags)
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)]
        let attributedString = NSMutableAttributedString(string: tags, attributes:attrs)
//        let normalText = NSMutableAttributedString(string: "\n" + jellies.jellyDescription!)
//        attributedString.append(normalText)
        
        tagLabel.attributedText = attributedString
        tagLabel.lineBreakMode = .byWordWrapping
        tagLabel.backgroundColor = UIColor(patternImage: UIImage(named: "gradient")!)
        tagLabel.layer.cornerRadius = tagLabel.frame.height/10
        tagLabel.clipsToBounds = true
        detailCalloutAccessoryView = tagLabel
        
        let detailButton = UIButton(frame: CGRect(origin: CGPoint.zero,size: CGSize(width: 40, height: 40)))
        detailButton.setBackgroundImage(UIImage(named: "Maps-Icon"), for: UIControl.State())
        rightCalloutAccessoryView = detailButton
    }
    
    func combineTags(_ tags: [String]) -> String {
        var allTags : String = ""
        for i in 0..<tags.count {
            if i < tags.count - 1 {
                allTags.append(tags[i] + ", ")
            }
            else {
                allTags.append(tags[i])
            }
        }
        return allTags
    }

}
