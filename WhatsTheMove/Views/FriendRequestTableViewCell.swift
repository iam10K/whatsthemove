//
//  FriendRequestTableViewCell.swift
//  WhatsTheMove
//
//  Created by De'Aira Bryant on 3/27/17.
//  Copyright © 2017 WhatsTheMove. All rights reserved.
//

import UIKit

class FriendRequestTableViewCell: UITableViewCell {
    
    var alertsTableViewController: AlertsTableViewController?
    var user: User?
    
    @IBOutlet weak var friendLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func initialize(with user: User, _ alertsTableViewController: AlertsTableViewController) {
        self.user = user
        self.alertsTableViewController = alertsTableViewController
        self.friendLabel.text = user.requestMessage()
    }
    
    @IBAction func declineAction() {
        if let alertsTableViewController = alertsTableViewController, let user = user {
            alertsTableViewController.acceptRequest(user: user)
        }
    }
    
    @IBAction func acceptAction() {
        if let alertsTableViewController = alertsTableViewController, let user = user {
            alertsTableViewController.declineRequest(user: user)
        }
    }
}
