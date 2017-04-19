//
//  AlertsTableViewController.swift
//  WhatsTheMove
//
//  Created by De'Aira Bryant on 3/27/17.
//  Copyright © 2017 WhatsTheMove. All rights reserved.
//

import UIKit

class AlertsTableViewController: UITableViewController {
    
    let WTM = WTMSingleton.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let user = WTM.user {
            if user.receivedRequestKeys.count > 0 || user.invitedEvents.count > 0 {
                self.tableView.backgroundView = nil
                self.tableView.separatorStyle = .singleLine
                return 2
            } else {
                emptyMessage(message: "No event invites or friend requests.", viewController: self)
                return 0
            }
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let user = WTM.user {
            switch section {
            case 0:
                let friendRequests = user.receivedRequestKeys
                return friendRequests.count
            case 1:
                let eventInvites = user.invitedEvents
                return eventInvites.count
            default:
                return 0
            }
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let user = WTM.user {
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "friendRequestTableViewCell", for: indexPath) as! FriendRequestTableViewCell
                cell.initialize(with: user.receivedRequestUsers[indexPath.row], self)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "eventInviteTableViewCell", for: indexPath) as! EventInviteTableViewCell
                cell.initialize(with: user.invitedEvents[indexPath.row], self)
                return cell
            default:
                return UITableViewCell()
            }
        }
        return UITableViewCell()
    }
    
    func emptyMessage(message:String, viewController:UITableViewController) {
        let messageLabel = UILabel(frame: CGRect(x: 0,y: 0, width: viewController.view.bounds.size.width, height: viewController.view.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        viewController.tableView.backgroundView = messageLabel;
        viewController.tableView.separatorStyle = .none;
    }
    
    func acceptRequest(user: User) {
        if let WTMUser = WTM.user {
            WTMUser.addFriend(user)
            self.tableView.reloadData()
        }
    }
    
    func declineRequest(user: User) {
        if let WTMUser = WTM.user {
            WTMUser.removeFriendRequest(user)
            self.tableView.reloadData()
        }
    }
    
    func interestEvent(eventId: String) {
        if let WTMUser = WTM.user {
            for event in WTM.eventsObservable.observableProperty {
                if event.key == eventId {
                    event.interest(WTMUser, completionHandler: {
                        self.tableView.reloadData()
                    })
                }
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
