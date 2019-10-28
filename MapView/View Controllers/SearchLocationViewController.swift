//
//  SearchLocationViewController.swift
//  MapView
//
//  Created by Elina Lua Ming on 10/26/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit

class SearchLocationViewController: UIViewController {
    
    @IBOutlet weak var SearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBarUI()
    }
    
    func configureSearchBarUI() {
        SearchBar.backgroundImage = UIImage()
        SearchBar.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        SearchBar.layer.borderWidth = 1.0
        SearchBar.layer.cornerRadius = SearchBar.frame.height/2
    }
    
}
