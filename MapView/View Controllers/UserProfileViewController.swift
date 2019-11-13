//
//  UserProfile.swift
//  MapView
//
//  Created by Elina Lua Ming on 10/2/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var displayPicture: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var displayName: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegation()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func configureDelegation() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 50
        tableView.separatorStyle = .singleLine
        tableView.sectionHeaderHeight = 50
    }
    
}

extension UserProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension UserProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        case 2:
            return 1
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                cell.setLabel(with: "Profile")
            }
            return cell
        case 1:
            if indexPath.row == 0 {
                cell.setLabel(with: "💖 Events")
            } else if indexPath.row == 1 {
                cell.setLabel(with: "Event History")
            } else if indexPath.row == 2 {
                cell.setLabel(with: "Future Events")
            }
            return cell
        case 2:
            if indexPath.row == 0 {
                cell.setLabel(with: "Settings")
            }
            return cell
        default:
            return cell
        }
    }
}
