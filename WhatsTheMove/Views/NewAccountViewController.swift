//
//  NewAccountViewController.swift
//  WhatsTheMove
//
//  Created by Tyler Encke on 10/10/16.
//  Copyright © 2016 WhatsTheMove. All rights reserved.
//

import UIKit
import Firebase

class NewAccountViewController: UIViewController {
    
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
    }
    
    // When the privacy level changes update the info text.
    @IBAction func privacyLevelChange(_ sender: UISegmentedControl) {
        privacyLevelInfoLabel.text = getPrivacyLevelInfoText(index: sender.selectedSegmentIndex)
    }
    
    // Create account action. Adds user info to the Firebase Database.
    @IBAction func createAccountAction() {
        // TODO: Create account. Use Firebase to create the user object.
        //
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
            return "Users can only view your profile, first name, and bio."
        case 2: // Friends-Only
            return "Only friends will see your profile, full name, bio, and events."
        default: // None selected
            return "Select a privacy level for your account."
        }
    }
}
