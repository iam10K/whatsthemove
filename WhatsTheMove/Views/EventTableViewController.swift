//
//  EventTableViewController.swift
//  WhatsTheMove
//
//  Created by Tyler Encke on 1/24/17.
//  Copyright © 2017 WhatsTheMove. All rights reserved.
//

import UIKit

class EventTableViewController: UITableViewController, UITextFieldDelegate {
    
    let WTM = WTMSingleton.instance
    
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Hide back button
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Display alert to user prompting to go to Maps
    func addressAlert() {
        if let event = event {
            let alertController = UIAlertController(title: event.location.addressName, message: event.location.address, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel,handler: nil))
            alertController.addAction(UIAlertAction(title: "Open in Maps", style: UIAlertActionStyle.default,handler: { action in self.addressLabelAction() }))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // Open the Maps app with address
    func addressLabelAction() {
        if let event = event {
            var newAddress = ""
            let addressValue = event.location.address
            
            newAddress = addressValue.replacingOccurrences(of: " ", with: "+").replacingOccurrences(of: "\n", with: "+")
            
            let addressUrl = "https://maps.apple.com/?q=" + newAddress
            let url = URL(string: addressUrl)
            if let url = url {
                UIApplication.shared.openURL(url as URL)
            } else {
                print("There was an error opening the Maps App")
            }
        }
    }
    
    func eventUpArrowAction() {
        if let user = WTM.auth.currentUser, let event = event {
            event.rateEvent(ofUser: user.uid, vote: true, completionHandler: {
                self.tableView.reloadData()
            })
        }
    }
    
    func eventDownArrowAction() {
        if let user = WTM.auth.currentUser, let event = event {
            event.rateEvent(ofUser: user.uid, vote: false, completionHandler: {
                self.tableView.reloadData()
            })
        }
    }
    
    func checkInAction() {
        if let user = WTM.auth.currentUser, let event = event {
            // If event is happening now allow checkin
            if event.isOccuring() {
                event.checkin(user: user.uid, completionHandler: {
                    self.tableView.reloadData()
                })
            } else if event.willOccur() {
                // Event will occur in the future
                // TODO: Message saying event is not occuring now
            }
        }
    }
    
    func interestedAction() {
        if let user = WTM.auth.currentUser, let event = event {
            event.interest(user: user.uid, completionHandler: {
                self.tableView.reloadData()
            })
        }
    }
    
    func moreAction() {
    }
    
    func commentUpArrowAction(_ commentKey: String) {
        if let user = WTMSingleton.instance.auth.currentUser, let event = event, let comment = event.getComment(commentKey) {
            comment.rateComment(ofUser: user.uid, vote: true, completionHandler: {
                self.tableView.reloadData()
            })
        }
    }
    
    func commentDownArrowAction(_ commentKey: String) {
        if let user = WTMSingleton.instance.auth.currentUser, let event = event, let comment = event.getComment(commentKey) {
            comment.rateComment(ofUser: user.uid, vote: false, completionHandler: {
                self.tableView.reloadData()
            })
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Dismiss the keyboard
        
        // Submit comment. Validate that length is acceptable
        if let comment = textField.text {
            if comment.characters.count > 2 {
                if comment.characters.count < 200 {
                    if let event = event, let user = WTM.user {
                        // Create comment and add to Firebase
                        let newCommentRef = WTM.dbRef.child("comments").child(event.key).childByAutoId()
                        let newComment = Comment(key: newCommentRef.key, comment: comment, user: user)
                        
                        newCommentRef.updateChildValues(newComment.toAnyObject()) { (error, _) in
                            if let error = error {
                                // TODO: Handle errors
                                print(error)
                            } else {
                                // Clear text field
                                textField.text = ""
                                
                                // Add to event
                                event.addComment(newComment)
                                
                                // Reload table view
                                self.tableView.reloadData()
                            }
                        }
                        
                    } else {
                        // TODO: Message, There was a problem commenting on this event.
                    }
                } else {
                    // TODO: Message, Comment must be under 200 characters.
                }
            } else {
                // TODO: Message, Comment must be longer than 2 characters.
            }
        }
        
        return true
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows in a section
        
        if let event = event {
            switch section {
            case 0:
                return 5
            case 1:
                // TODO: Return number of comments + 1
                if event.comments.count > 10 {
                    return 11
                }
                return event.comments.count + 1
            default:
                return 0
            }
        }
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let event = event, let user = WTM.user {
            
            // Event info section
            if indexPath.section == 0 {
                
                switch indexPath.row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "eventTitleTableViewCell", for: indexPath) as! EventTitleTableViewCell
                    cell.initialize(with: event)
                    return cell
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "eventOptionsTableViewCell", for: indexPath) as! EventOptionsTableViewCell
                    cell.initialize(with: event)
                    cell.addActions(self, interestedAction: #selector(interestedAction), checkInAction: #selector(checkInAction), moreAction: #selector(moreAction))
                    return cell
                case 2:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "eventLocationTableViewCell", for: indexPath) as! EventLocationTableViewCell
                    cell.initialize(with: event)
                    return cell
                case 3:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "eventSponsorTableViewCell", for: indexPath) as! EventSponsorTableViewCell
                    cell.initialize(with: event)
                    return cell
                case 4:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "eventStatsTableViewCell", for: indexPath) as! EventStatsTableViewCell
                    cell.initialize(with: event, for: user)
                    cell.addActions(self, upArrowAction:  #selector(eventUpArrowAction), downArrowAction: #selector(eventDownArrowAction))
                    return cell
                default:
                    break
                }
                
                // Event comments section
            } else if indexPath.section == 1 {
                if indexPath.row == event.comments.count || indexPath.row == 10 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "eventNewCommentTableViewCell", for: indexPath) as! EventNewCommentTableViewCell
                    return cell
                }
                let comment = event.comments[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: "eventCommentTableViewCell", for: indexPath) as! EventCommentTableViewCell
                cell.initialize(with: comment, tableController: self)
                return cell
                
            }
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Display option to open maps when the user selects the address row.
        if indexPath.section == 0 && indexPath.row == 2 {
            addressAlert()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Comments"
        }
        return nil
    }
    
}
