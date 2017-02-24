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
    
    var commentKey: String? = ""
    
    var tableController: EventTableViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initialize(with comment: Comment, tableController: EventTableViewController) {
        self.commentKey = comment.key
        self.tableController = tableController
        
        // Set labels
        senderLabel.text = "\(comment.displayName) - \(Utils.format(date: comment.createdDate))"
        messageLabel.text = comment.text
        ratingLabel.text = String(comment.rating)
        
        if let user = WTMSingleton.instance.auth.currentUser {
            comment.updateRatingArrows(ofUser: user.uid, upButton: upButton, downButton: downButton)
        }
        
        // Add actions to buttons
        upButton.addTarget(self, action: #selector(commentUpVote), for: .touchUpInside)
        downButton.addTarget(self, action: #selector(commentDownVote), for: .touchUpInside)
    }

    func commentUpVote() {
        if let tableController = tableController, let commentKey = commentKey {
            tableController.commentUpArrowAction(commentKey)
        }
    }
    
    func commentDownVote() {
        if let tableController = tableController, let commentKey = commentKey {
            tableController.commentDownArrowAction(commentKey)
        }
    }
}
