//
//  SquadViewController.swift
//  Calhacks
//
//  Created by Justin Yu on 11/3/18.
//  Copyright © 2018 Justin Yu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SquadViewController: UIViewController, UITextFieldDelegate {
    
    var squadMembers: NSDictionary!
    @IBOutlet weak var addUsers: UITextField!
    var tableViewController: SquadTableViewController!
    
    @IBAction func addMembers(_ sender: Any) {
        let ref = Database.database().reference()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        //need to add authentication
        
        guard let emailToAdd = addUsers.text else { return }
        
        // First, get the other user's email by looping through users and checking if email matches addUsers.text
        ref.child("users").observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                let temp = child as! DataSnapshot
                if let val = temp.value as? NSDictionary {
                    
                    if val["email"] as! String == emailToAdd {
                        let idToAdd = temp.key
                        
                        ref.child("users/\(uid)").observeSingleEvent(of: .value, with: { (s) in
                            if let value = s.value as? NSDictionary {
                                let myEmail = Auth.auth().currentUser?.email!
                                if s.hasChild("group") && value["group"] as! Int != 0 {
                                    let temp = value["group"] as! Int
                                    let BAC = value["BAC"] as! Double
                                    //add UID of member to group
                                    //assign group id to
                                    ref.child("users/\(idToAdd)/group").setValue(temp)
                                    // Add new user to group.
                                    ref.child("groups/\(temp)/\(idToAdd)/email").setValue(emailToAdd)
                                    ref.child("groups/\(temp)/\(idToAdd)/status").setValue("member")
                                    ref.child("groups/\(temp)/\(idToAdd)/BAC").setValue(BAC)
                                } else {
                                    let newGroup = Int(NSDate.timeIntervalSinceReferenceDate*1000)
                                    let BAC = value["BAC"] as! Double
                                    ref.child("groups/\(newGroup)/\(uid)/email").setValue(myEmail)
                                    ref.child("groups/\(newGroup)/\(uid)/status").setValue("member")
                                    ref.child("groups/\(newGroup)/\(uid)/BAC").setValue(BAC)
                                    ref.child("groups/\(newGroup)/\(idToAdd)/email").setValue(emailToAdd)
                                    ref.child("groups/\(newGroup)/\(idToAdd)/status").setValue("member")
                                    ref.child("groups/\(newGroup)/\(idToAdd)/BAC").setValue(BAC)
                                    ref.child("users/\(uid)/group").setValue(newGroup)
                                    ref.child("users/\(idToAdd)/group").setValue(newGroup)
                
                                    //otherwise, generate group id
                                    //add both members to group
                                    //set group attribute of both members
                                }
                            }
                        })
                    }
                }
            }
        }
        
        self.addUsers.text = ""
        
        listOut()
        //display new user by querying group database
        //value can be whether they are designated driver or not
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listOut()
        self.addUsers.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func listOut() {
        let ref = Database.database().reference()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child("users/\(uid)").observeSingleEvent(of: .value) { (snapshot) in
            print("User updated")
            if let value = snapshot.value as? NSDictionary {
                if snapshot.hasChild("group") {
                    guard let groupId = value["group"] as? Int else { return }
                    // Look for all children of the group that the current user is part of.
                    ref.child("groups/\(groupId)").observeSingleEvent(of: .value, with: { (snapshot) in
                        if let squad = snapshot.value {
                            let temp = squad as! NSDictionary
                            self.tableViewController?.setSquadMembers(squad: temp)
//                            self.tableViewController?.setSquadMembers(squad: temp.allValues as! [NSDictionary])
                        }
                    })
                }
            }
        }
        self.tableViewController.tableView.reloadData()
        //loop over each element in the group
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmbedSegue" {
            let destination = segue.destination as! SquadTableViewController
            self.tableViewController = destination
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
