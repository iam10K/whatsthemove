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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
}
