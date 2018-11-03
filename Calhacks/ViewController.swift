//
//  ViewController.swift
//  Calhacks
//
//  Created by Justin Yu on 11/3/18.
//  Copyright © 2018 Justin Yu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let name = nameTextField.text!
        let height = Int(heightTextField.text!)!
        let weight = Int(weightTextField.text!)!
        let age = Int(ageTextField.text!)!
        let gender = genderTextField.text!
        
        if segue.identifier == "SignUpSegue" {
            if let dashboardViewController = segue.destination as? DashboardViewController {
                dashboardViewController.user = User(name: name, height: height, weight: weight, age: age, gender: gender)
            }
        }
    }

}

