//
//  Weather_LoggerUITests.swift
//  Weather LoggerUITests
//
//  Created by Mike Haydan on 10/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import XCTest

class Weather_LoggerUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_show_details() {
        XCUIApplication().tables/*@START_MENU_TOKEN@*/.cells.buttons["Details >"]/*[[".cells.buttons[\"Details >\"]",".buttons[\"Details >\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
    }
    
    func test_show_details_save_delete() {
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        let detailsButton = tablesQuery/*@START_MENU_TOKEN@*/.buttons["Details >"]/*[[".cells.buttons[\"Details >\"]",".buttons[\"Details >\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        detailsButton.tap()
        tablesQuery.buttons["Save"].tap()
        app.alerts.buttons["Ok"].tap()
        app.navigationBars["Uzhhorod"].buttons["Weather list"].tap()
        detailsButton.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Delete"]/*[[".cells.buttons[\"Delete\"]",".buttons[\"Delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
}
