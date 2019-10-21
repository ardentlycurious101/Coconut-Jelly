//
//  FilterTagsViewController.swift
//  MapView
//
//  Created by Elina Lua Ming on 10/2/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit

class SearchTagsViewController: UIViewController {
    
    // MARK:- Table view variables
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:- View controller life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegation()
    }
    
    //MARK:- Helper functions
    
    func configureCheckmark(for cell: UITableViewCell, at indexPath: IndexPath) {
 
        if existingTagDictionary[existingTags[indexPath.row]] == true {
            cell.accessoryType = .none
            existingTagDictionary[existingTags[indexPath.row]] = false
        } else {
            cell.accessoryType = .checkmark
            existingTagDictionary[existingTags[indexPath.row]] = true
        }
    }
    
    func loadCheckmark(for cell: TagCell, at indexPath: IndexPath) {
        
        if existingTagDictionary[existingTags[indexPath.row]] == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
    
    func configureDelegation() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.rowHeight = 50
    }
}

extension SearchTagsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return existingTags.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagCell", for: indexPath) as! TagCell
        cell.setLabels(label: existingTags[indexPath.row])
        loadCheckmark(for: cell, at: indexPath)
        return cell
    }

}

extension SearchTagsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            configureCheckmark(for: cell, at: indexPath)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


