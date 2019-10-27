//
//  UIColor+Extensions.swift
//  MapView
//
//  Created by Elina Lua Ming on 10/22/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}
