//
//  ProfileHeaderTableViewCell.swift
//  WhatsTheMove
//
//  Created by Tyler Encke on 2/23/17.
//  Copyright © 2017 WhatsTheMove. All rights reserved.
//

import UIKit

class ProfileHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventsCreatedLabel: UILabel!
    @IBOutlet weak var eventsAttendedLabel: UILabel!
    @IBOutlet weak var friendsLabel: UILabel!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var profileButton: UIButton!
    
    var profileController: ProfileTableViewController? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func initialize(with user: User, profileController: ProfileTableViewController) {
        // Set labels to values from user
        eventsCreatedLabel.text = String(user.createdEventsKeys.count)
        eventsAttendedLabel.text = String(user.attendedEventsKeys.count)
        friendsLabel.text = String(user.friendsKeys.count)
        displayNameLabel.text = user.name
        bioLabel.text = user.bio
        
        self.profileController = profileController
        
        if let WTMUser = profileController.WTM.user {
            if WTMUser.sentRequest(user.key) {
                if let titleLabel = profileButton.titleLabel {
                    titleLabel.text = "Pending..."
                }
            }
            if WTMUser.receivedRequest(user.key) {
                if let titleLabel = profileButton.titleLabel {
                    titleLabel.text = "Accept Request"
                }
            }
            if WTMUser.areFriends(user.key) {
                if let titleLabel = profileButton.titleLabel {
                    titleLabel.text = "Remove Friend"
                }
            }
        }
        
        self.profileButton.addTarget(self, action: #selector(profileButtonAction), for: .touchUpInside)
    }
    
    func profileButtonAction() {
        if let profileController = profileController {
            profileController.profileButtonAction()
        }
    }
}
