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

    var newEvent: Event? = nil
    var selectingStartDate: Bool = true
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        calendar.placeholderType = FSCalendarPlaceholderType.none
        tabBarController?.tabBar.isHidden = true
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
        // Gather all the date components to construct new date
        let curCalendar = Calendar.current
        let dateComponents = curCalendar.dateComponents([.year, .month, .day], from: calendar.selectedDate as Date)
        let timeComponents = curCalendar.dateComponents([.hour, .minute], from: timePicker.date as Date)
        
        // Get all values for new date
        let year =  dateComponents.year
        let month = dateComponents.month
        let day = dateComponents.day
        let hour =  timeComponents.hour
        let minute = timeComponents.minute
        
        // Create new date from components
        var selectedComponents = DateComponents()
        selectedComponents.year = year
        selectedComponents.month = month
        selectedComponents.day = day
        selectedComponents.hour = hour
        selectedComponents.minute = minute
        
        let selectedDate = curCalendar.date(from: selectedComponents)
        
        // Assign new date to the start or end date
        if let newEvent = newEvent, let selectedDate = selectedDate {
            if selectingStartDate {
                newEvent.startDate = selectedDate
            } else {
                newEvent.endDate = selectedDate
            }
        }
    }
    

}
