//
//  FeedTableViewController.swift
//  WhatsTheMove
//
//  Created by Tyler Encke on 12/3/16.
//  Copyright © 2016 WhatsTheMove. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {
    
    @IBOutlet weak var SortFeedControl: UISegmentedControl!
    
    let WTM = WTMSingleton.instance
    
    var events: [Event] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if let allEvents = WTM.events {
            events = allEvents
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Default sort by popularity
        sortByPopularity()
        
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedTableViewCell
        
        if indexPath.row < events.count {
            let event = events[indexPath.row]
            cell.populate(with: event)
        }
        
        return cell
    }
    
    //Sorts the events array by popularity to be used in sortfeedchange method
    func sortByPopularity(){
        
        self.events = events.sorted(by: {$0.rating > $1.rating});
    }
    
    //sorts the events array by date to be used in sortfeedchange method
    func sortByDate(){
        
        self.events = events.sorted(by: {$0.startDate.timeIntervalSince1970 > $1.startDate.timeIntervalSince1970});
        
    }
    
    // When the desired feed sort changes update the list of events
    @IBAction func sortFeedChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            sortByPopularity()
        case 1:
            sortByDate()
        default:
            sortByPopularity()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < events.count {
            let event = events[indexPath.row]
            
            // Push to event view
            performSegue(withIdentifier: "eventTableViewSegue", sender: event)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "eventTableViewSegue" {
            let vc = segue.destination as! EventTableViewController
            vc.event = sender as? Event
        }
    }
    
    @IBAction func showInterestedAction(_ sender: Any) {
        if let user = WTM.user {
            if events == user.interested {
                if let allEvents = WTM.events {
                    events = allEvents
                }
            } else {
                events = user.interested
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
