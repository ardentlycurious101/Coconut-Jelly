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
    
}
