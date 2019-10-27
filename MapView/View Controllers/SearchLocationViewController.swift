//
//  SearchLocationViewController.swift
//  MapView
//
//  Created by Elina Lua Ming on 10/26/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit

class SearchLocationViewController: UIViewController {
    
    @IBAction func BackButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension SearchLocationViewController: UINavigationBarDelegate {
    
    
}
