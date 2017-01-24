//
//  WhatsTheMoveUITests.swift
//  WhatsTheMoveUITests
//
//  Created by Tyler Encke on 9/20/16.
//  Copyright © 2016 WhatsTheMove. All rights reserved.
//

import XCTest
@testable import WhatsTheMove

class WhatsTheMoveUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        testLoginEmailPassword()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        testLogout()
    }
    
    private func testLoginEmailPassword() {
        let app = XCUIApplication()
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("demo@demo.com")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("P@$$w0rd")
        app.buttons["Login"].tap()
    }
    
    private func testLogout() {
        let app = XCUIApplication()
        app.tabBars.children(matching: .button).element(boundBy: 4).tap()
        app.navigationBars["Profile"].buttons["Logout"].tap()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
