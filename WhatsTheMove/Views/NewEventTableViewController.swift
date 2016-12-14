//
//  NewEventTableViewController.swift
//  WhatsTheMove
//
//  Created by Tyler Encke on 11/3/16.
//  Copyright © 2016 WhatsTheMove. All rights reserved.
//

import UIKit

class NewEventTableViewController: UITableViewController, UITextFieldDelegate {
    
    let WTM = WTMSingleton.instance

    @IBOutlet weak var eventTitleField: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationAddressLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var privacyControl: UISegmentedControl!
    @IBOutlet weak var friendsCanInviteSwitch: UISwitch!
    @IBOutlet weak var sponsorField: UITextField!
    @IBOutlet weak var entryNotesField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Date formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy \'at\' h:mm a"
        
        // Generate string for start and end date
        let startDateString = formatter.string(from: WTM.newEvent.startDate)
        let endDateString = formatter.string(from: WTM.newEvent.endDate)
        // Set the label value for start and end date each time view appears
        startDateLabel.text = startDateString
        endDateLabel.text = endDateString
        
        
        // Set location to the selected location
        if WTM.newEvent.location.addressName == "" {
            locationLabel.textColor = UIColor.lightGray
        } else {
            locationLabel.textColor = UIColor.black
            locationLabel.text = WTM.newEvent.location.addressName
        }
        
        if WTM.newEvent.location.address == "" {
            locationAddressLabel.textColor = UIColor.lightGray
        } else {
            locationAddressLabel.textColor = UIColor.black
            locationAddressLabel.text = WTM.newEvent.location.address
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectDateControllerSegue" {
            if let vc = segue.destination as? SelectDateViewController {
                
                if let selectedRow = tableView.indexPathForSelectedRow {
                    let row = selectedRow.row
                    let section = selectedRow.section
                    
                    if section == 1 && row == 0 {
                        vc.selectingStartDate = true
                    } else if section == 1 && row == 1 {
                        vc.selectingStartDate = false
                    }
                    
                    tableView.deselectRow(at: selectedRow, animated: false)
                }
            }
        }
    }
    
    @IBAction func createEventAction(_ sender: AnyObject) {
        // TODO Validate Event Values
        
        // If valid add to database, if not display error messages
        addToDatabase(for: WTM.newEvent)
    }
    
    @IBAction func cancelAction(_ sender: AnyObject) {
        // Clear newEvent
        WTM.newEvent = Event()
        
        // Push to Feed View Controller
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") as? UITabBarController
        self.present(vc!, animated: false)
    }
    
    // Store all field values in the newEvent object
    private func storeValuesInEvent(completion: () -> ()) {
        if let title = eventTitleField.text {
            WTM.newEvent.title = title
        }
        if let eventDescription = descriptionField.text {
            WTM.newEvent.eventDescription = eventDescription
        }
        WTM.newEvent.privacyLevel = privacyControl.selectedSegmentIndex
        WTM.newEvent.friendsCanInvite = friendsCanInviteSwitch.isOn
        if let sponsor = sponsorField.text {
            WTM.newEvent.sponsor = sponsor
        }
        if let entryNote = entryNotesField.text {
            WTM.newEvent.entryNote = entryNote
        }
        completion()
    }
    
    // Add the new event to the database, validate value before!
    private func addToDatabase(for e: Event) {
        storeValuesInEvent() {
            let newEventRef = WTM.dbRef.child("events").childByAutoId()
            if let user = WTM.auth.currentUser {
                e.creatorId = user.uid
                e.createdDate = Date()
                newEventRef.updateChildValues(e.toAnyObject()) { (error, _) in
                    if let error = error {
                        print(error)
                    } else {
                        // Clear newEvent
                        self.WTM.newEvent = Event()
                    }
                }
                
                // Clear newEvent
                WTM.newEvent = Event()
            }
        
            // TODO: Change this to Push to created event
            // Push to Feed View Controller
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") as? UITabBarController
            self.present(vc!, animated: false)
        }
    }
    
    // Formats the date based on how far in future it is.
    // Dates == today will format as Today at h:mm a
    // Dates within 7 days will format EEE at h:mm a
    // In same year will format MMMM d at h:mm a
    // Else MMM d, yyyy at h:mm a
    private func format(date: Date) -> String {
        // TODO
        return ""
    }
    
    // TODO Keyboard next button goes to next field.
    // http://stackoverflow.com/questions/9540500/ios-app-next-key-wont-go-to-the-next-text-field
    // http://stackoverflow.com/questions/1347779/how-to-navigate-through-textfields-next-done-buttons
    
}
