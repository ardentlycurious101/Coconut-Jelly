//
//  MyTabBarController.swift
//  MapView
//
//  Created by Elina Lua Ming on 10/8/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController, UINavigationControllerDelegate {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 1
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
}
