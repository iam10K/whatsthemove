//
//  EventOptionsTableViewCell.swift
//  WhatsTheMove
//
//  Created by Tyler Encke on 2/13/17.
//  Copyright © 2017 WhatsTheMove. All rights reserved.
//

import UIKit

class EventOptionsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var interestedButton: UIButton!
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func initialize(with event: Event) {
        
        // TODO: Set interest button to be filled in if user has shown interest
    }
    
    func addActions(_ target: Any, interestedAction a1: Selector, checkInAction a2: Selector, moreAction a3: Selector) {
        
        // Add actions to buttons
        interestedButton.addTarget(target, action: a1, for: .touchUpInside)
        checkInButton.addTarget(target, action: a2, for: .touchUpInside)
        moreButton.addTarget(target, action: a3, for: .touchUpInside)
    }
}
