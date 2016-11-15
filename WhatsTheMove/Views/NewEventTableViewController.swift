//
//  NewEventTableViewController.swift
//  WhatsTheMove
//
//  Created by Tyler Encke on 11/3/16.
//  Copyright © 2016 WhatsTheMove. All rights reserved.
//

import UIKit

class NewEventTableViewController: UITableViewController {
    
    var newEvent: Event = Event()

    @IBOutlet weak var eventTitleField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var privacyControl: UISegmentedControl!
    @IBOutlet weak var friendsCanInviteSwitch: UISwitch!
    @IBOutlet weak var sponsorField: UITextField!
    @IBOutlet weak var entryNotes: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Date formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy \'at\' h:mm a"
        
        // Generate string for start and end date
        let startDateString = formatter.string(from: newEvent.startDate)
        let endDateString = formatter.string(from: newEvent.endDate)
        // Set the label value for start and end date each time view appears
        startDateLabel.text = startDateString
        endDateLabel.text = endDateString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectDateControllerSegue" {
            if let vc = segue.destination as? SelectDateViewController {
                vc.newEvent = newEvent
                
                if let selectedRow = tableView.indexPathForSelectedRow {
                    let row = selectedRow.row
                    let section = selectedRow.section
                    
                    if section == 1 && row == 0 {
                        vc.selectingStartDate = true
                    } else if section == 1 && row == 1 {
                        vc.selectingStartDate = false
                    }
                }
            }
        }
    }
    
    @IBAction func createEventAction(_ sender: AnyObject) {
        
    }
    
    // Formats the date based on how far in future it is.
    // Dates == today will format as Today at h:mm a
    // Dates within 7 days will format EEE at h:mm a
    // In same year will format MMMM d at h:mm a
    // Else MMM d, yyyy at h:mm a
    private func format(date: Date) -> String {
        
        return ""
    }
}
