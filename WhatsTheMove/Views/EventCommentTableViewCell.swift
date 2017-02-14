//
//  EventCommentTableViewCell.swift
//  WhatsTheMove
//
//  Created by Tyler Encke on 2/13/17.
//  Copyright © 2017 WhatsTheMove. All rights reserved.
//

import UIKit

class EventCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initialize(with comment: Comment) {
        senderLabel.text = "\(comment.displayName) - \(Utils.format(date: comment.createdDate))"
        messageLabel.text = comment.text
        ratingLabel.text = String(comment.rating)
    }

}
