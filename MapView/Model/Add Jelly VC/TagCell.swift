//
//  TagCell.swift
//  MapView
//
//  Created by Elina Lua Ming on 10/9/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit

class TagCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    func setLabels(label: String) {
        self.label.text = label
    }
    
    func configureUI() {
        label.textColor = .white
        self.backgroundColor = .black
    }
    
    func changeTextColor(for isCheckmark: Bool) {
        if isCheckmark {
            label.textColor = UIColor(patternImage: UIImage(named: "gradient")!)
//            label.textColor = .black
//            label.backgroundColor = UIColor(patternImage: UIImage(named: "gradient")!)
//            label.layer.cornerRadius = label.frame.height/2
//            label.clipsToBounds = true
        } else {
            label.textColor = .white
//            label.backgroundColor = .black
        }
    }
    
}
