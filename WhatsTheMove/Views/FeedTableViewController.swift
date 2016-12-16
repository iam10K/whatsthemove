//
//  FeedTableViewController.swift
//  WhatsTheMove
//
//  Created by Tyler Encke on 12/3/16.
//  Copyright © 2016 WhatsTheMove. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {
    
    let WTM = WTMSingleton.instance
    
    var events: [Event]? {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad(
        ) {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        events = WTM.events
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        guard events != nil else { return 0 }
        return events!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedTableViewCell

        if let events = events {
            cell.titleLabel.text = events[indexPath.row].title
            cell.addressNameLabel.text = events[indexPath.row].location.addressName
            cell.ratingLabel.text = String(events[indexPath.row].rating)
            
            // Date formatter
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy \'at\' h:mm a"
            
            // Generate string for start date
            let startDateString = formatter.string(from: events[indexPath.row].startDate)
            // Set the label value for start and end date each time view appears
            cell.dateLabel.text = startDateString
            
        }

        return cell
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
