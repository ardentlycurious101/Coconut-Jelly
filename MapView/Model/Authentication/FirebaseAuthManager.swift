//
//  FirebaseAuthManager.swift
//  MapView
//
//  Created by Elina Lua Ming on 11/12/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit
import FirebaseAuth

class FirebaseAuthManager {
    
    func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let user = authResult?.user {
                print(user)
                completionBlock(true)
            } else {
//                print("ERROR: ")
//                print(error?.localizedDescription)
                completionBlock(false)
            }
        }
    }
    
    func loginUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let user = authResult?.user {
                print(user)
                completionBlock(true)
            } else {
//                print("ERROR: ")
//                print(error?.localizedDescription)
                completionBlock(false)
            }
        }
    }

}
