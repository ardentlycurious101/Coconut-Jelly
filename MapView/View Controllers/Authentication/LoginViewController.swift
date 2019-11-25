//
//  LoginViewController.swift
//  MapView
//
//  Created by Elina Lua Ming on 11/12/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func LoginButtonTapped(_ sender: Any) {
        let signInManager = FirebaseAuthManager()
        
        if let email = emailField.text, let password = passwordField.text {
            signInManager.loginUser(email: email, password: password) { [weak self](success) in
                
                guard let `self` = self else { return }
                
                var message: String = ""
                
                if success {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "LoginSegue", sender: self)
                    }
                } else {
                    message = "Error logging in."
                    
                    self.emailField.text = nil
                    self.passwordField.text = nil

                    self.alertUser(with: message)
                }
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if UserDefaults.standard.bool(forKey: "usersignedin") {
//            performSegue(withIdentifier: "LoginSegue", sender: self)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "usersignedin") {
            performSegue(withIdentifier: "LoginSegue", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func alertUser(with message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

}
