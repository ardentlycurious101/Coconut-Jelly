//
//  TextField.swift
//  MapView
//
//  Created by Elina Lua Ming on 10/26/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit

class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
        
    func configureUI() {
        self.layer.cornerRadius = self.frame.size.height/2
        self.textColor = .white
        self.backgroundColor = GlobalBackgroundColor
        self.borderStyle = .roundedRect
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(patternImage: UIImage(named: "gradient")!).cgColor
        self.clipsToBounds = true
    }
    
}
