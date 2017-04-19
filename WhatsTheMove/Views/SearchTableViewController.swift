//
//  SearchTableViewController.swift
//  WhatsTheMove
//
//  Created by Thomas Gladden on 2/13/17.
//  Copyright © 2017 WhatsTheMove. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchResultsUpdating {
    
    let WTM = WTMSingleton.instance
    
    var results: [Event] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Set up search bar
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false
        self.definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        self.navigationItem.titleView = searchController.searchBar
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func filterEvents(_ searchString: String) {
        var filtered: [Event] = []
        let events = self.WTM.eventsObservable.observableProperty
        
        for event in events {
            if event.title.lowercased().contains(searchString.lowercased()) {
                filtered.append(event)
            }
        }
        filtered = filtered.sorted(by: {$0.startDate.timeIntervalSince1970 > $1.startDate.timeIntervalSince1970})
        results = filtered
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedTableViewCell
        
        if indexPath.row < results.count {
            let event = results[indexPath.row]
            cell.populate(with: event)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < results.count {
            let event = results[indexPath.row]
            
            // Push to event view
            performSegue(withIdentifier: "eventTableViewSegue", sender: event)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Hide keyboard when going to next view
        searchController.searchBar.resignFirstResponder()
        
        if segue.identifier == "eventTableViewSegue" {
            let vc = segue.destination as! EventTableViewController
            vc.event = sender as? Event
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterEvents(searchText)
        }
    }
}
