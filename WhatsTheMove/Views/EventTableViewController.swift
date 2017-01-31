//
//  EventTableViewController.swift
//  WhatsTheMove
//
//  Created by Tyler Encke on 1/24/17.
//  Copyright © 2017 WhatsTheMove. All rights reserved.
//

import UIKit

class EventTableViewController: UITableViewController {
    
    let WTM = WTMSingleton.instance
    
    var event: Event?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addressNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var sponsorLabel: UILabel!
    @IBOutlet weak var entryLabel: UILabel!
    
    @IBOutlet weak var attendingLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var checkedInLabel: UILabel!
    
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
        
        populateTable()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateTable() {
        if let event = event {
            titleLabel.text = event.title
            descriptionLabel.text = event.eventDescription
            
            timeLabel.text = Utils.format(startDate: event.startDate, endDate: event.endDate)
            addressNameLabel.text = event.location.addressName
            addressLabel.text = event.location.address
            
            
            // TODO: If only one change height of cell?
            sponsorLabel.text = event.sponsor
            entryLabel.text = event.entryNote
            
            attendingLabel.text = "0"
            ratingLabel.text = String(event.rating)
            checkedInLabel.text = "0"
            
            if let user = WTM.auth.currentUser {
                event.updateRatingArrows(ofUser: user.uid, upButton: upButton, downButton: downButton)
            }
        }
    }
    
    @IBAction func upArrowAction() {
        if let user = WTM.auth.currentUser, let event = event {
            event.rateEvent(ofUser: user.uid, vote: true, ratingLabel: ratingLabel)
            event.updateRatingArrows(ofUser: user.uid, upButton: upButton, downButton: downButton)
        }
    }
    
    @IBAction func downArrowAction() {
        if let user = WTM.auth.currentUser, let event = event {
            event.rateEvent(ofUser: user.uid, vote: false, ratingLabel: ratingLabel)
            event.updateRatingArrows(ofUser: user.uid, upButton: upButton, downButton: downButton)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: - Table view data source
    
    /*override func numberOfSections(in tableView: UITableView) -> Int {
     // #warning Incomplete implementation, return the number of sections
     return 0
     }*/
    
    /*override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     // #warning Incomplete implementation, return the number of rows
     return 0
     }*/
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
