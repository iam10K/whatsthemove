//
//  NewAccountViewController.swift
//  WhatsTheMove
//
//  Created by Tyler Encke on 10/10/16.
//  Copyright © 2016 WhatsTheMove. All rights reserved.
//

import UIKit

class NewAccountViewController: UIViewController {
    
    let WTM = WTMSingleton.instance
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var privacyLevelControl: UISegmentedControl!
    @IBOutlet weak var privacyLevelInfoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardWhenTappedAround() 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func usernameEditEnded() {
        if let username = usernameField.text {
            validateUsername(of: username)
        }
    }
    
    // When the privacy level changes update the info text.
    @IBAction func privacyLevelChange(_ sender: UISegmentedControl) {
        privacyLevelInfoLabel.text = getPrivacyLevelInfoText(index: sender.selectedSegmentIndex)
    }
    
    // Create account action. Adds user info to the Firebase Database.
    @IBAction func createAccountAction() {
        // Validate entered values
        if let username = usernameField.text {
            validateUsername(of: username, completion: { (result) in
                if result {
                    self.addUserToDatabase()
                }
            })
        }
    }
    
    func addUserToDatabase() {
        if let username = usernameField.text,
            let name = nameField.text,
            let user = WTM.auth.currentUser {
            
            if let email = user.email {
                
                WTM.dbRef.child("users").child(user.uid).updateChildValues([
                    "username": username,
                    "name": name,
                    "privacyLevel": privacyLevelControl.selectedSegmentIndex,
                    "email": email
                    ])
                WTM.dbRef.child("usernames").child(username).setValue(user.uid, andPriority: nil)
                
                // Push to Feed View Controller
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") as? UITabBarController
                self.present(vc!, animated: true)
            }
        }
    }
    
    // TODO Keyboard next button goes to next field.
    // http://stackoverflow.com/questions/9540500
    // http://stackoverflow.com/questions/1347779
    
    // Returns the info about privacy levels 0,1,2.
    func getPrivacyLevelInfoText(index: Int) -> String {
        switch (index) {
        case 0: // Public
            return "Everyone can view your profile, full name, bio, and events."
        case 1: // Private
            return "Only your friends can view your profile, full name, bio, and events."
        default: // None selected
            return "Select a privacy level for your account."
        }
    }
    
    // Validate that the username matches the correct pattern
    func validateUsername(of username: String, completion: ((Bool) -> Void)? = nil) {
        var validUsername = false
        
        if username == "" {
            completion?(false)
            return
        }
        
        if let result = username.range(of: "^[a-zA-Z0-9_-]{4,20}$", options: .regularExpression) {
            if result.isEmpty {
                // TODO: Message, username can only contain alphanumeric and underscore
                completion?(false)
                return
            } else {
                validUsername = true
            }
        } else {
            // TODO: Message, username can only contain alphanumeric and underscore
            completion?(false)
            return
        }
        
        // Use Firebase database to check if user name is take
        WTM.dbRef.child("usernames").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(username) {
                // Username is taken already
                
                if completion != nil {
                    // TODO: Message, username taken, only show if there is completion handler
                }
                
                print("TAKEN")
                completion?(false)
                return
            } else {
                // Username is not taken
                validUsername = true
            }
            
            // Complete
            completion?(validUsername)
            
        }) { (error) in
            print(error.localizedDescription)
            completion?(false)
        }
    }
}
