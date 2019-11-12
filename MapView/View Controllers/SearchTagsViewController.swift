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
    @IBOutlet weak var TitleSearchTagsVC: UILabel!
    @IBOutlet weak var TopView: UIView!
    
    // MARK:- View controller life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegation()
        configureUI()
    }
    
    //MARK:- Helper functions
    
    func configureUI() {
        TitleSearchTagsVC.textColor = UIColor(patternImage: UIImage(named: "gradient")!)
        self.view.backgroundColor = .black
        TopView.backgroundColor = .black
        self.tableView.backgroundColor = .black
    }
    
    func configureCheckmark(for cell: UITableViewCell, at indexPath: IndexPath) {
//        cell.textLabel?.textColor = .white
//        cell.backgroundColor = .black
        let cell = cell as! TagCell
        
        if existingTagDictionary[existingTags[indexPath.row]] == true {
            cell.accessoryType = .none
            cell.changeTextColor(for: false)
            existingTagDictionary[existingTags[indexPath.row]] = false
        } else {
            cell.accessoryType = .checkmark
            cell.changeTextColor(for: true)
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
        // set label
        cell.setLabels(label: existingTags[indexPath.row])
        loadCheckmark(for: cell, at: indexPath)
        // configure cell text and background color
        cell.configureUI()
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


