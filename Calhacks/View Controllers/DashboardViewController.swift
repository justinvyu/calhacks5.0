//
//  DashboardViewController.swift
//  Calhacks
//
//  Created by Justin Yu on 11/3/18.
//  Copyright © 2018 Justin Yu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class DashboardViewController: UIViewController {
    @IBOutlet weak var bacLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    var updateTimer: Timer!
    
    @IBOutlet weak var beerButton: UIButton!
    @IBOutlet weak var shotButton: UIButton!
    @IBOutlet weak var wineButton: UIButton!
    
    @IBAction func logOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            if let storyboard = self.storyboard {
                let vc = storyboard.instantiateViewController(withIdentifier: "LandingPageVC")
                self.present(vc, animated: true, completion: nil)
            }
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError.localizedDescription)
        }
    }
    
    @IBAction func reset(_ sender: Any) {
        let ref = Database.database().reference()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child("users/\(uid)/BAC").setValue(0)
        updateBAC()
        ref.child("users/\(uid)").observe(.value, with: { (s) in
            if s.hasChild("group") {
                ref.child("users/\(uid)/group").removeValue()
            }
        })
    }
    
    
    @IBAction func Beer(_ sender: Any) {
        let ref = Database.database().reference()
        let timeInterval = NSDate().timeIntervalSince1970
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        //get current user, check if list of drinks is empty, if it is, create one, recalculate BAC level based upon user
        ref.child("users/\(uid)").observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                print(value)
                guard let weight = value["weight"] as? Double else { return }
                let kilo = weight / 2.205
                guard let sex = value["sex"] as? String else { return }
                var bw = 0.5
                var m = 0.017
                if sex == "Male" {
                    bw = 0.6
                    m = 0.015
                }
                var bac = (0.806 * 1 * 1.2) / (bw * kilo) - m * (1 / 3) // BAC equation
                print(bac)
                
                guard let timeSince = value["time"] as? Double else { return }
                guard let prevBAC = value["BAC"] as? Double else { return }
                if timeSince != 0 {
                    let timeDifference = (timeInterval - timeSince) / 3600
                    print(timeDifference)
                    let bacChange = prevBAC - m * timeDifference
                    print(bacChange)
                    if bacChange > 0 {
                        bac = bac + bacChange
                    }
                }
                let timeLeft = bac / m
                let hours = Int(timeLeft)
                let minutes = Int((timeLeft - Double(hours)) * 60)
                print(minutes)
                print(hours)
                self.timerLabel.text = "\(hours) hr \(minutes) min until sober"
                ref.child("users/\(uid)/time").setValue(timeInterval)
                ref.child("users/\(uid)/BAC").setValue(bac)
                self.bacLabel.text = String(format: "%0.4f%", bac)
            }
            if snapshot.hasChild("drinks") {
                if let value = snapshot.value as? NSDictionary {
                    let drinks = value["drinks"]
                    print(drinks)
                }
            } else {
                //create list and append to list
            }
        })
        
        //get user BAC
        // calculate
    }
    
    @objc func updateBAC() {
        let ref = Database.database().reference()
        //get current user, check if list of drinks is empty, if it is, create one, recalculate BAC level based upon user
        let timeInterval = NSDate().timeIntervalSince1970
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child("users/\(uid)").observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                guard let sex = value["sex"] as? String else { return }
                var m = 0.017
                if sex == "Male" {
                    m = 0.015
                }
                guard let timeSince = value["time"] as? Double else { return }
                guard var prevBAC = value["BAC"] as? Double else { return }
                let timeDifference = (timeInterval - timeSince) / 3600
                if timeSince != 0 { // If there hasn't been a first drink yet,
                    
                    //add it in the other function as well
                    let bacChange = prevBAC - m * timeDifference
                    ref.child("users/\(uid)/time").setValue(timeInterval)
                    if bacChange > 0 {
                        prevBAC = bacChange
                        let timeLeft = prevBAC / m
                        ref.child("users/\(uid)/BAC").setValue(prevBAC)
                        let hours = Int(timeLeft)
                        let minutes = Int((timeLeft - Double(hours)) * 60)
                        print(minutes)
                        print(hours)
                        self.timerLabel.text = "\(hours) hr \(minutes) min until sober"
                        self.bacLabel.text = String(format: "%0.4f%", prevBAC)
                    } else {
                        ref.child("users/\(uid)/BAC").setValue(0)
                        self.timerLabel.text = "00 hr 00 min until sober"
                        print("CALLED FUNCTION")
                        self.bacLabel.text = String(format: "%0.4f%", 0)
                    }
                }
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //add to list of drinks
        //update / calculate BAC based on last time drank
        updateBAC()
        self.updateTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(DashboardViewController.updateBAC), userInfo: nil, repeats: true)
        
        let topLeft = UIColor(red: 116/255, green: 185/255, blue: 1, alpha: 1).cgColor
        let middle = UIColor(red: 9/255, green: 132/255, blue: 227/255, alpha: 1).cgColor
        let bottomRight = UIColor(red: 162/255, green: 155/255, blue: 254/255, alpha: 1).cgColor
        self.view.gradientLayer.colors = [topLeft, bottomRight]
        self.view.gradientLayer.gradient = GradientPoint.topLeftBottomRight.draw()
    }
    
    deinit {
        self.updateTimer.invalidate()
    }

}
