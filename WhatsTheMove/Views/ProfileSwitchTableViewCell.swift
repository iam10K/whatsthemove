//
//  ProfileSwitchTableViewCell.swift
//  WhatsTheMove
//
//  Created by Tyler Encke on 2/23/17.
//  Copyright © 2017 WhatsTheMove. All rights reserved.
//

import UIKit

class ProfileSwitchTableViewCell: UITableViewCell {
    
    var profileController: ProfileTableViewController?
    @IBOutlet weak var switchControl: UISegmentedControl!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func initialize(with profileController: ProfileTableViewController) {
        self.profileController = profileController
        
        // Remove rounded corners from segmented control
        self.switchControl.layer.borderColor = self.switchControl.tintColor.cgColor;
        self.switchControl.layer.cornerRadius = 0.0
        self.switchControl.layer.borderWidth = 1.5
    }
    
    @IBAction func sortFeedChange(_ sender: UISegmentedControl) {
        if let profileController = profileController {
            profileController.switchShownEvents(sender.selectedSegmentIndex)
        }
    }
}
