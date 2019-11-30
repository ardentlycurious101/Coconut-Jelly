//
//  JelliesTags.swift
//  MapView
//
//  Created by Elina Lua Ming on 11/29/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit

public class JelliesTags: NSObject, NSCoding {
    
    var tags: [String]
    
    init(tags: [String]) {
        self.tags = tags
        super.init()
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(tags, forKey: "tags")
    }
    
    public required init?(coder: NSCoder) {
        self.tags = coder.decodeObject(forKey: "tags") as! [String]
    }

}
