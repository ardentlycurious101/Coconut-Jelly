//
//  Switcher.swift
//  MapView
//
//  Created by Elina Lua Ming on 11/12/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit
import FirebaseAuth

class Switcher {
    
    static func updateRootVC(loginStatus: Bool) {
        
        var rootVC : UIViewController?
        
//        print(status)
        
        if (loginStatus == true) {
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarVC") as! MyTabBarController

        } else {
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC
        
    }
    
    
}
