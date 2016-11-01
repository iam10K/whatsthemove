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
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var privacyLevelControl: UISegmentedControl!
    @IBOutlet weak var privacyLevelInfoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Username has been entered. Check Firebase Database to make sure username does not exist.
    // http://stackoverflow.com/questions/38134789
    @IBAction func usernameEditEnded() {
    // TODO: Use link above, one of three options. Second or third option would be preferable.
        if let username = usernameField.text {
            if !validateUsername(username: username) {
                // TODO: Display message to user that username is taken of not valid.
            }
        }
    }
    
    // When the privacy level changes update the info text.
    @IBAction func privacyLevelChange(_ sender: UISegmentedControl) {
        privacyLevelInfoLabel.text = getPrivacyLevelInfoText(index: sender.selectedSegmentIndex)
    }
    
    // Create account action. Adds user info to the Firebase Database.
    @IBAction func createAccountAction() {
        // Validate entered values
        if !validateFields() {
            return
        }
        
        if let username = usernameField.text,
            let firstName = firstNameField.text,
            let lastName = lastNameField.text,
            let user = WTM.auth.currentUser {
            WTM.dbRef.child("users").child(user.uid).updateChildValues(["username": username, "firstName": firstName, "lastName": lastName, "privacyLevel": privacyLevelControl.selectedSegmentIndex])
        }
        
        // Push to Feed View Controller
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") as? UITabBarController
        self.present(vc!, animated: true)
    }
    
    // TODO Keyboard next button goes to next field.
    // http://stackoverflow.com/questions/9540500
    // http://stackoverflow.com/questions/1347779
    
    // Returns the info about privacy levels 0,1,2.
    private func getPrivacyLevelInfoText(index: Int) -> String {
        switch (index) {
        case 0: // Public
            return "Everyone can view your profile, full name, bio, and events."
        case 1: // Private
            return "Only your friends can view your profile, full name, bio, and events."
        default: // None selected
            return "Select a privacy level for your account."
        }
    }
    
    // Validate that the username is not taken and is valid, true if valid
    private func validateUsername(username: String) -> Bool {
        var valid = true
        
        // TODO: Use REGEX to validate usename is a-zA-Z0-9_
        
        // Use Firebase database to check if user name is take
        WTM.dbRef.child("users").child(username).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                // Username is taken already
                valid = false
            } else {
                // Username is not taken
                valid = true
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        return valid
    }
    
    // Validate username, first and last name. Displays popup messages if any field is invalid
    private func validateFields() -> Bool {
        return true;
    }
}
