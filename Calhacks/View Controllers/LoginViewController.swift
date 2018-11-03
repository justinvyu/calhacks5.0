//
//  LoginViewController.swift
//  Calhacks
//
//  Created by Justin Yu on 11/3/18.
//  Copyright © 2018 Justin Yu. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func login(_ sender: Any) {
        guard let email = emailTextField.text as String? else { return }
        guard let password = passwordTextField.text as String? else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if error == nil {
                
            } else {
                print("Error signing in: \(error?.localizedDescription)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
