//
//  EventTitleTableViewCell.swift
//  WhatsTheMove
//
//  Created by Tyler Encke on 2/13/17.
//  Copyright © 2017 WhatsTheMove. All rights reserved.
//

import UIKit

class EventTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
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
        titleLabel.text = event.title
        descriptionLabel.text = event.eventDescription
    }
}
