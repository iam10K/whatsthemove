//
//  SelectDateViewController.swift
//  WhatsTheMove
//
//  Created by Tyler Encke on 11/14/16.
//  Copyright © 2016 WhatsTheMove. All rights reserved.
//

import UIKit
import FSCalendar

class SelectDateViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {

    var newEvent: Event?
    var selectingStartDate: Bool = true
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        calendar.placeholderType = FSCalendarPlaceholderType.none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if selectingStartDate {
            title = "Start Date"
        } else {
            title = "End Date"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneSelectingDate(_ sender: AnyObject) {
        
    }
    

}
