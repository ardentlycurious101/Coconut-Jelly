//
//  TagCell.swift
//  MapView
//
//  Created by Elina Lua Ming on 10/9/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit

class TagCell: UITableViewCell {
    
    enum filterState {
        case off
        case on
    }
    
    @IBOutlet weak var label: UILabel!
    
    func setLabels(label: String) {
        self.label.text = label
    }
    
    func configureUI() {
        label.textColor = .white
        self.tintColor = UIColor(red: 126, green: 209, blue: 205)
        self.backgroundColor = UIColor(red: 20, green: 32, blue: 42)
    }
    
    func changeTextColor(for isCheckmark: Bool) {
        if isCheckmark == true {
            label.textColor = UIColor(red: 126, green: 209, blue: 205)
        } else {
            label.textColor = .white
        }

    }
    
}
