//
//  WhatsTheMoveTests.swift
//  WhatsTheMoveTests
//
//  Created by Tyler Encke on 9/20/16.
//  Copyright © 2016 WhatsTheMove. All rights reserved.
//

import XCTest
@testable import WhatsTheMove

class WhatsTheMoveTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testValidateUsername() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "newAccountViewController") as? NewAccountViewController
        
        guard vc != nil else {
            return
        }
        
        let validUsernames = ["fqyhHg8QUTrGlcAPUX","XUPAc_UT5Rsjp","SDDS_G67-99p"]
        let invalidUsernames = ["char$das","abc"];
        
        for validUsername in validUsernames {
            
            vc!.validateUsername(of: validUsername, completion: { (result) in
                XCTAssertTrue(result)
            })
        }
        
        for invalidUsername in invalidUsernames {
            vc!.validateUsername(of: invalidUsername, completion: { (result) in
                XCTAssertFalse(result)
            })
        }
    }
    
    func testFormatDate() {
        let date = Date()
        let curCalendar = Calendar.current
        let dateComponents = curCalendar.dateComponents([.year, .month, .day], from: date)
        
        let day = dateComponents.day
        let month = dateComponents.month
        let year = dateComponents.year
        
        // Create new date from components to remove time
        var futureComponents = DateComponents()
        futureComponents.year = year
        futureComponents.month = month
        futureComponents.day = day
        
        let futureDate = curCalendar.date(from: futureComponents)
        
        // Test today
        XCTAssertTrue(Utils.format(date: date).contains("Today"))
        
        if var futureDate = futureDate {
            
            // Test 1 day later
            futureDate.addTimeInterval(86400)
            var result = Utils.format(date: futureDate)
            XCTAssertTrue(!result.contains(String(day!)))
            
            // Test 8 days later
            futureDate.addTimeInterval(604800)
            result = Utils.format(date: futureDate)
            XCTAssertTrue(!result.contains(String(year!)))
            
            // Test 1 year later
            futureDate.addTimeInterval(3.154e+7)
            result = Utils.format(date: futureDate)
            XCTAssertTrue(result.contains(String(year!+1)))
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
