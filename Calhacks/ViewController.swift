//
//  ViewController.swift
//  Calhacks
//
//  Created by Justin Yu on 11/3/18.
//  Copyright © 2018 Justin Yu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = Database.database().reference()
    }

    @IBAction func createUser(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let name = nameTextField.text!
        let height = Int(heightTextField.text!)!
        let weight = Int(weightTextField.text!)!
        let age = Int(ageTextField.text!)!
        let gender = genderTextField.text!
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            print(error)
            guard let user = authResult?.user else { return }
            print(user)
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//
//        if segue.identifier == "SignUpSegue" {
//            if let dashboardViewController = segue.destination as? DashboardViewController {
//                dashboardViewController.user = User(name: name, height: height, weight: weight, age: age, gender: gender)
//            }
//        }
//    }

}

