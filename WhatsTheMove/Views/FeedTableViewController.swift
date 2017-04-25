//
//  FeedTableViewController.swift
//  WhatsTheMove
//
//  Created by Tyler Encke on 12/3/16.
//  Copyright © 2016 WhatsTheMove. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {
    
    @IBOutlet weak var sortFeedControl: UISegmentedControl!
    
    let WTM = WTMSingleton.instance
    
    var events: [Event] = []
    
    var displayedEvents: [Event] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var displayingInterested: Bool = false
    var sortedBy: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Remove rounded corners from segmented control
        self.sortFeedControl.layer.borderColor = self.sortFeedControl.tintColor.cgColor;
        self.sortFeedControl.layer.cornerRadius = 0.0
        self.sortFeedControl.layer.borderWidth = 1.5
        
        self.events = self.WTM.eventsObservable.observableProperty
        self.displayEvents()
        
        WTM.eventsObservable.addObserver(identifier: "tableViewObserver", observer: (pre: {_,_ in } , post: {_,_ in
            self.events = self.WTM.eventsObservable.observableProperty
            self.displayEvents()
        }))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if displayedEvents.count > 0 {
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .singleLine
            return 1
        } else {
            emptyMessage(message: "No events occuring now or in the future.", viewController: self)
            return 0
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedEvents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedTableViewCell
        
        if indexPath.row < displayedEvents.count {
            let event = displayedEvents[indexPath.row]
            cell.populate(with: event)
        }
        
        return cell
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
    
    //Sorts the events array by popularity or time
    func sort() {
        switch sortedBy {
        case 0:
            self.displayedEvents = displayedEvents.sorted(by: {$0.rating > $1.rating})
        case 1:
            self.displayedEvents = displayedEvents.sorted(by: {$0.startDate.timeIntervalSince1970 < $1.startDate.timeIntervalSince1970})
        default:
            self.displayedEvents = displayedEvents.sorted(by: {$0.rating > $1.rating})
        }
        self.tableView.reloadData()
    }
    
    // When the desired feed sort changes update the list of events
    @IBAction func sortFeedChange(_ sender: UISegmentedControl) {
        sortedBy = sender.selectedSegmentIndex
        self.sort()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < displayedEvents.count {
            let event = displayedEvents[indexPath.row]
            
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
        // Change list of events showing and then display
        displayingInterested = !displayingInterested
        
        self.displayEvents()
    }
    
    func filterEvents() {
        let calender = NSCalendar.autoupdatingCurrent
        let newDate = calender.date(byAdding: .minute, value: -180, to: Date())
        if let newDate = newDate {
            for event in displayedEvents {
                if event.startDate < newDate {
                    if let index = displayedEvents.index(of: event) {
                        displayedEvents.remove(at: index)
                    }
                }
            }
        }
    }
    
    func displayEvents() {
        if let user = WTM.user {
            if displayingInterested {
                // Set list of displayed events to the users interested events
                displayedEvents = user.interested
                
                // Set the title
                self.navigationItem.title = "Interested"
            } else {
                // Set the list of displayed events to all events
                displayedEvents = events
                
                // Set the title
                self.navigationItem.title = "Feed"
            }
        }
        self.filterEvents()
        self.sort()
    }
}
