//
//  FilterTagsViewController.swift
//  MapView
//
//  Created by Elina Lua Ming on 10/2/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit

class SearchTagsViewController: UITableViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return existingTags.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagCell", for: indexPath)
        if let label = cell.viewWithTag(100) as? UILabel {
                label.text = existingTags[indexPath.row]
        }
        loadCheckmark(for: cell, at: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            configureCheckmark(for: cell, at: indexPath)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func configureCheckmark(for cell: UITableViewCell, at indexPath: IndexPath) {
        if existingTagDictionary[existingTags[indexPath.row]] == true {
            cell.accessoryType = .none
            existingTagDictionary[existingTags[indexPath.row]] = false
        } else {
            cell.accessoryType = .checkmark
            existingTagDictionary[existingTags[indexPath.row]] = true
        }
    }
    
    func loadCheckmark(for cell: UITableViewCell, at indexPath: IndexPath) {
        if existingTagDictionary[existingTags[indexPath.row]] == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }

}
