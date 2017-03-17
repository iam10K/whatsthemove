//
//  FeedTableViewCell.swift
//  WhatsTheMove
//
//  Created by Tyler Encke on 12/16/16.
//  Copyright © 2016 WhatsTheMove. All rights reserved.
//

import UIKit
import Firebase
class FeedTableViewCell: UITableViewCell {
    
    let WTM = WTMSingleton.instance
    
    var event: Event? = nil
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func populate(with event: Event) {
        self.event = event
        titleLabel.text = event.title
        addressNameLabel.text = event.location.addressName
        dateLabel.text = Utils.format(date: event.startDate)
        ratingLabel.text = String(event.rating)
        
        if let user = WTM.auth.currentUser {
            event.updateRatingArrows(ofUser: user.uid, upButton: upButton, downButton: downButton)
        }
    }
    
    @IBAction func upArrowAction() {
        if let user = WTM.auth.currentUser, let event = event {
            event.rateEvent(ofUser: user.uid, vote: true, ratingLabel: ratingLabel)
            event.updateRatingArrows(ofUser: user.uid, upButton: upButton, downButton: downButton)
            self.setNeedsDisplay()
        }
    }
    
    @IBAction func downArrowAction() {
        if let user = WTM.auth.currentUser, let event = event {
            event.rateEvent(ofUser: user.uid, vote: false, ratingLabel: ratingLabel)
            event.updateRatingArrows(ofUser: user.uid, upButton: upButton, downButton: downButton)
        }
    }

}
