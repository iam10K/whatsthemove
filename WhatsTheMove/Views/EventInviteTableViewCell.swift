//
//  EventInviteTableViewCell.swift
//  WhatsTheMove
//
//  Created by De'Aira Bryant on 3/27/17.
//  Copyright © 2017 WhatsTheMove. All rights reserved.
//

import UIKit

class EventInviteTableViewCell: UITableViewCell {
    
    var eventId: String?
    var alertsTableViewController: AlertsTableViewController?
    
    @IBOutlet weak var inviteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func initialize(with invite: Invite, _ alertsTableViewController: AlertsTableViewController) {
        self.eventId = invite.eventId
        self.alertsTableViewController = alertsTableViewController
        self.inviteLabel.text = invite.inviteMessage()
    }
    
    @IBAction func interestAction() {
        if let alertsTableViewController = alertsTableViewController, let eventId = eventId {
            alertsTableViewController.interestEvent(eventId: eventId)
        }
    }
    
}
