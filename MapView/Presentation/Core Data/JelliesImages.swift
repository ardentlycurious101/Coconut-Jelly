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
    
}
