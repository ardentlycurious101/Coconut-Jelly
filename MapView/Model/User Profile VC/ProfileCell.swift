//
//  ProfileCell.swift
//  MapView
//
//  Created by Elina Lua Ming on 10/9/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    func setLabel(with name: String) {
        label.text = name
    }
    

}
