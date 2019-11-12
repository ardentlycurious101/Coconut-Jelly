//
//  Button.swift
//  MapView
//
//  Created by Elina Lua Ming on 10/28/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit

class Button: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func configureUI() {
        self.layer.cornerRadius = self.frame.size.height/2
//        self.backgroundColor = UIColor(red: 126, green: 209, blue: 205)
        self.clipsToBounds = true
    }

}
