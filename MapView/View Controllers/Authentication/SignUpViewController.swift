//
//  SignUpViewController.swift
//  MapView
//
//  Created by Elina Lua Ming on 11/12/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    @IBAction func SignUpButtonTapped(_ sender: Any) {
        let signUpManager = FirebaseAuthManager()
        
        if let email = emailField.text, let password = passwordField.text {
            signUpManager.createUser(email: email, password: password) { [weak self] (success) in
                
                guard let `self` = self else { return }
                var message: String = ""
                
                if success {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "SignUpSegue", sender: self)
                    }
                } else {
                    message = "Error when creating account."
                    self.alertUser(with: message)
                }
            }
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
