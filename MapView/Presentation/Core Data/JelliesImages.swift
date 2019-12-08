//
//  JelliesImages.swift
//  MapView
//
//  Created by Elina Lua Ming on 11/29/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit

public class JelliesImages: NSObject, NSCoding {
    
    var imagesData: [Data]
    
    init(data: [Data]) {
        imagesData = data
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(imagesData, forKey: "images")
    }
    
    public required init?(coder: NSCoder) {
        imagesData = coder.decodeObject(forKey: "images") as! [Data]
    }
    
    func append(_ image: Data) {
        imagesData.append(image)
    }
    
    func getImages() -> [UIImage] {
        var images: [UIImage] = []
        print("the number of images in this imagesData: \(imagesData.count)")
        guard imagesData.count > 0 else { return images }
        
        for image in imagesData {
            let image = UIImage(data: image)
            images.append(image!)
        }
        
        return images
        
    }
    
}
