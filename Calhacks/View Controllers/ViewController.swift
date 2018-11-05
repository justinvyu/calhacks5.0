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
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var sexToggle: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = Database.database().reference()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        print(uid)
        
        
    }
    @IBAction func Back(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createUser(_ sender: Any) {
        // Retrieve user information to create user in Firebase
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let name = nameTextField.text!
        let weight = Int(weightTextField.text!)!
        let sex = sexToggle.titleForSegment(at: sexToggle.selectedSegmentIndex)
        
        // Create user based on what's passed in through the text fields
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error == nil && authResult != nil {
                guard let user = authResult?.user else { return }
                let ref = Database.database().reference()
                ref.child("users/\(user.uid)/name").setValue(name)
                ref.child("users/\(user.uid)/weight").setValue(weight)
                ref.child("users/\(user.uid)/sex").setValue(sex)
                ref.child("users/\(user.uid)/BAC").setValue(0)
                ref.child("users/\(user.uid)/time").setValue(0)
                ref.child("users/\(user.uid)/email").setValue(email)             
            } else {
                print("Error creating user: ", error?.localizedDescription)
            }
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

