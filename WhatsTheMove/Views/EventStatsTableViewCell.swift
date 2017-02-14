//
//  EventStatsTableViewCell.swift
//  WhatsTheMove
//
//  Created by Tyler Encke on 2/13/17.
//  Copyright © 2017 WhatsTheMove. All rights reserved.
//

import UIKit

class EventStatsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var interestedLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var checkedInLabel: UILabel!

    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var upButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initialize(with event: Event, for user: User) {
        // Set labels to values from event
        interestedLabel.text = String(event.interested)
        ratingLabel.text = String(event.rating)
        checkedInLabel.text = String(event.checkedIn)
        
        // Setup buttons for rating event
        event.updateRatingArrows(ofUser: user.key, upButton: upButton, downButton: downButton)
    }
    
    func addActions(_ target: Any, upArrowAction a1: Selector, downArrowAction a2: Selector) {
        // Add action for up and down buttons
        upButton.addTarget(target, action: a1, for: .touchUpInside)
        downButton.addTarget(target, action: a2, for: .touchUpInside)
    }

}
