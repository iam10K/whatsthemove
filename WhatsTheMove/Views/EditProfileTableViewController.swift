//
//  EditProfileTableViewController.swift
//  WhatsTheMove
//
//  Created by Tyler Encke on 4/6/17.
//  Copyright © 2017 WhatsTheMove. All rights reserved.
//

import UIKit

class EditProfileTableViewController: UITableViewController {
    
    let WTM = WTMSingleton.instance

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var bioField: UITextView!
    @IBOutlet weak var privacyControl: UISegmentedControl!
    @IBOutlet weak var privacyMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if let user = WTM.user {
            nameField.text = user.name
            bioField.text = user.bio
            privacyControl.selectedSegmentIndex = user.privacyLevel
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Returns the info about privacy levels 0,1,2.
    func getPrivacyLevelInfoText(index: Int) -> String {
        switch (index) {
        case 0: // Public
            return "Everyone can view your full name and events."
        case 1: // Private
            return "Only your friends can view your full name and events."
        default: // None selected
            return "Select a privacy level for your account."
        }
    }
    
    @IBAction func privacyControlChange(_ sender: UISegmentedControl) {
        privacyMessage.text = getPrivacyLevelInfoText(index: sender.selectedSegmentIndex)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        if let bio = bioField.text {
            if bio.characters.count > 255 {
                let alert = UIAlertController(title: "Alert", message: "Bio must be less than 256 characters.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss ", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
        if let name = nameField.text {
            if name.characters.count > 29 {
                let alert = UIAlertController(title: "Alert", message: "Name must be less than 30 characters.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss ", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
        if let user = WTM.user {
            if let ref = user.ref {
                ref.updateChildValues([
                "name": nameField.text ?? "",
                "bio": bioField.text ?? "",
                "privacyLevel": privacyControl.selectedSegmentIndex
                ]) {_,_ in
                    user.name = self.nameField.text ?? ""
                    user.bio = self.bioField.text ?? ""
                    user.privacyLevel = self.privacyControl.selectedSegmentIndex
                    _ = self.navigationController?.popViewController(animated: true)
                }
                
            }
        }
    }
}
