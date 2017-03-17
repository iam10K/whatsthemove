//
//  ProfileTableViewController.swift
//  WhatsTheMove
//
//  Created by Tyler Encke on 12/3/16.
//  Copyright © 2016 WhatsTheMove. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    let WTM = WTMSingleton.instance
    
    var user: User?
    
    var showingCreated: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if let user = user {
            self.navigationItem.title = user.username
            user.loadCreatedEvents() {
                self.tableView.reloadData()
            }
            user.loadAttendedEvents() {
                self.tableView.reloadData()
            }
        } else {
            if let user = WTM.user {
                self.user = user
                self.navigationItem.title = user.username
            }
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let user = user {
            if showingCreated {
                return 2 + user.createdEvents.count
            } else {
                return 2 + user.attendedEvents.count
            }
        }
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row > 1 {
            return 100
        }
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Switch based on which row. Any row after first two are just the events from attended or created
        if let user = user {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "profileHeaderTableViewCell", for: indexPath) as! ProfileHeaderTableViewCell
                cell.initialize(with: user, profileController: self)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "profileSwitchTableViewCell", for: indexPath) as! ProfileSwitchTableViewCell
                cell.initialize(with: self)
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedTableViewCell
                if showingCreated {
                    if indexPath.row-2 < user.attendedEvents.count {
                        let event = user.attendedEvents[indexPath.row-2]
                        cell.populate(with: event)
                    }
                } else {
                    if indexPath.row-2 < user.createdEvents.count {
                        let event = user.createdEvents[indexPath.row-2]
                        cell.populate(with: event)
                    }
                }
                
                return cell
            }
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let user = user {
            if showingCreated {
                if indexPath.row < user.attendedEvents.count {
                    let event = user.attendedEvents[indexPath.row]
                    
                    // Push to event view
                    performSegue(withIdentifier: "eventTableViewSegue", sender: event)
                }
            } else {
                if indexPath.row < user.createdEvents.count {
                    let event = user.createdEvents[indexPath.row]
                    
                    // Push to event view
                    performSegue(withIdentifier: "eventTableViewSegue", sender: event)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "eventTableViewSegue" {
            let vc = segue.destination as! EventTableViewController
            vc.event = sender as? Event
        }
    }
    
    func switchShownEvents(_ index: Int) {
        if index == 0 {
            showingCreated = false
            self.tableView.reloadData()
        } else {
            showingCreated = true
            self.tableView.reloadData()
        }
    }
    
    func profileButtonAction() {
        if let user = user, let WTMUser = WTM.user {
            if user.key == WTMUser.key {
                // FUTURE: Edit profile
            } else if !WTMUser.areFriends(user.key) {
                // Add friends
                WTMUser.addFriend(user)
                self.tableView.reloadData()
            } else {
                //Remove Friend
                WTMUser.removeFriend(user)
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func logoutAction(_ sender: UIBarButtonItem) {
        do {
            try WTM.auth.signOut()
        } catch {
            print("Error")
        }
        
        // TODO: If logged in with facebook log out from facebook
        
        // Push to Login View Controller
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginViewController") as? LoginViewController
        self.present(vc!, animated: true)
        
    }
    
}
