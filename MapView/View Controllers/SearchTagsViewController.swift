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
    @IBOutlet weak var filterSwitch: UISwitch!
    
    // reference TagManager
    let tagManager = TagManager.shared

    // MARK:- View controller life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegation()
        configureUI()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView(_:)), name: .tagAdded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(turnOffFilter(_:)), name: .turnOffFilter, object: nil)
        filterSwitch.addTarget(self, action: #selector(filterSwitchChanged(_:)), for: UIControl.Event.valueChanged)
        filterSwitch.isOn = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- Helper functions
    @objc func turnOffFilter(_ notification: Notification) {
        filterSwitch.isOn = false
    }
    
    @objc func filterSwitchChanged(_ filterSwitch: UISwitch) {
        if filterSwitch.isOn {
            tagManager.changeFilterSwitchState(isOn: true)
            tableView.reloadData()
            NotificationCenter.default.post(name: .filteredJellyAdded, object: nil)
        } else {
            tagManager.changeFilterSwitchState(isOn: false)
            tableView.reloadData()
            NotificationCenter.default.post(name: .useAllJellies, object: nil)
        }
    }
    
    @objc func reloadTableView(_ notification: Notification) {
        // reload table view
        tableView.reloadData()
    }

    func configureUI() {
        self.view.backgroundColor = UIColor(red: 20, green: 32, blue: 42)
        TopView.backgroundColor = UIColor(red: 20, green: 32, blue: 42)
        self.tableView.backgroundColor = UIColor(red: 20, green: 32, blue: 42)
    }
    
    func configureCheckmark(for cell: UITableViewCell, at indexPath: IndexPath) {

        let cell = cell as! TagCell
        let dictionary = tagManager.getDictionary()
        let key = tagManager.sortedTags[indexPath.row]
        
        if dictionary[key] == true {
            cell.accessoryType = .none
            cell.changeTextColor(for: false)
            tagManager.setDictionary(key: key, value: false)
            
            var index: Int = -1
            var count: Int = -1
            var tagNotFound: Bool = true
            
            for jelly in MapViewManager.shared.filteredJellies {
                count += 1
                // filtered jellies contain jellies, remove jelly
                if jelly.tagNames.contains(cell.label.text!) {
                    tagNotFound = false
                    index = count
                }
            }

            if index >= 0 && !tagNotFound {
                // if jellies still have checked tags, don't remove
                // else remove
                let jellyToCheck = MapViewManager.shared.filteredJellies[index]
                if noCheckedTagsLeft(for: jellyToCheck) {
                    MapViewManager.shared.filteredJellies.remove(at: index)
                }
            }
            
            // if none checked, add all annotations (using unfiltered jellies)
            // else, add only checked annotations (using filtered jellies)
            
            if MapViewManager.shared.filteredJellies.count == 0 {
                NotificationCenter.default.post(name: .useAllJellies, object: nil)
            } else {
                NotificationCenter.default.post(name: .filteredJellyAdded, object: nil)
            }
            
            
        } else {
            cell.accessoryType = .checkmark
            cell.changeTextColor(for: true)
            tagManager.setDictionary(key: key, value: true)
            
            for jelly in MapViewManager.shared.unfilteredJellies {
                
                if jelly.tagNames.contains(cell.label.text!) {
                    
                    // loop through filtered jelly
                    // if found, then break
                    // if not found, then append, and break
                    
                    var jellyNotFound: Bool = true

                    for filteredJelly in MapViewManager.shared.filteredJellies {
                        
                        let title = filteredJelly.title!
                        let jellyTitle = jelly.title!
                        
                        if title == jellyTitle {
                            jellyNotFound = false
                        }
                    }
            
                    if jellyNotFound {
                        MapViewManager.shared.filteredJellies.append(jelly)
                    }
                }
            }
            
            NotificationCenter.default.post(name: .filteredJellyAdded, object: nil)
        }
    }
    
    func noCheckedTagsLeft(for jelly: Jelly) -> Bool {
        // check tag dictionary for true keys.
        // check if jelly tags contains any of the true keys
        // if not, then return true
        // else if jelly tags has one of the true keys, return false
        for (key, value) in tagManager.getDictionary() {
            if value == true {
                if jelly.tagNames.contains(key) {
                    return false
                }
            }
        }
        
        return true
    }
    
    func switchState(_ isOn: Bool, for cell: TagCell) {
        if isOn == false {
            cell.label.textColor = .gray
            cell.tintColor = .gray
        } else {
            cell.tintColor = UIColor(red: 126, green: 209, blue: 205)
        }
    }
    
    func loadCheckmarkAndTextColor(for cell: TagCell, at indexPath: IndexPath) {
        
        let dictionary = tagManager.getDictionary()
        let key = tagManager.sortedTags[indexPath.row]
        
        if dictionary[key] == true {
            cell.accessoryType = .checkmark
            cell.changeTextColor(for: true)
        } else {
            cell.accessoryType = .none
            cell.changeTextColor(for: false)
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
        return tagManager.sortedTags.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagCell", for: indexPath) as! TagCell
        // set label
        cell.setLabels(label: tagManager.sortedTags[indexPath.row])
        loadCheckmarkAndTextColor(for: cell, at: indexPath)
        switchState(filterSwitch.isOn, for: cell)
        return cell
    }

}

extension SearchTagsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if filterSwitch.isOn {
            if let cell = tableView.cellForRow(at: indexPath) {
                configureCheckmark(for: cell, at: indexPath)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


