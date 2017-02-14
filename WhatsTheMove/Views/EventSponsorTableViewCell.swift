//
//  EventSponsorTableViewCell.swift
//  WhatsTheMove
//
//  Created by Tyler Encke on 2/13/17.
//  Copyright © 2017 WhatsTheMove. All rights reserved.
//

import UIKit

class EventSponsorTableViewCell: UITableViewCell {

    @IBOutlet weak var sponsorLabel: UILabel!
    @IBOutlet weak var entryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initialize(with event: Event) {
        // Set labels to values from event
        sponsorLabel.text = event.sponsor
        entryLabel.text = event.entryNote
    }

}
