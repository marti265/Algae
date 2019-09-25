
//
//  Algae_EstimatorUITests.swift
//  Algae EstimatorUITests
//
//  Created by App Factory on 9/30/16.
//  Copyright © 2016 Software Engineering. All rights reserved.
//

import XCTest

class Algae_EstimatorUITests: XCTestCase {
        
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
    
    func testCreate() {
        
        
        let app = XCUIApplication()
        let scrollViewsQuery = app.scrollViews
        
        let cTextField = app.scrollViews.children(matching: .textField).matching(identifier: "°C").element(boundBy: 0)
        cTextField.tap()
        
        app.keys["1"].tap()
        app.keys["5"].tap()
        let nextButton = XCUIApplication().toolbars.buttons["Next"]
        nextButton.tap()
        
        app.keys["5"].tap()
        nextButton.tap()
        
        app.keys["4"].tap()
        nextButton.tap()
        
        app.keys["2"].tap()
        app.keys["0"].tap()
        app.keys["0"].tap()
        nextButton.tap()
        
        scrollViewsQuery.children(matching: .button).matching(identifier: "SET").element(boundBy: 0).tap()
        
        let po4TextField = app.scrollViews.children(matching: .textField).matching(identifier: "mg/L").element(boundBy: 0)
        po4TextField.tap()
        
        app.keys["4"].tap()
        nextButton.tap()
        
        app.buttons["SUBMIT"].tap()
        
        scrollViewsQuery.children(matching: .button).matching(identifier: "SET").element(boundBy: 0).tap()
        
        let totalChlTextField = app.scrollViews.children(matching: .textField).matching(identifier: "μg/L").element(boundBy: 0)
        totalChlTextField.tap()
        app.keys["5"].tap()
        app.keys["0"].tap()
        nextButton.tap()
        app.keys["7"].tap()
        app.keys["0"].tap()
        
        app.buttons["SUBMIT"].tap()
        
        app.buttons["SUBMIT"].tap()
        
    }
    
    func testCreate2() {
        
        
        let app = XCUIApplication()
        let scrollViewsQuery = app.scrollViews
        
        let cTextField = app.scrollViews.children(matching: .textField).matching(identifier: "°C").element(boundBy: 0)
        cTextField.tap()
        
        app.keys["2"].tap()
        app.keys["7"].tap()
        let nextButton = XCUIApplication().toolbars.buttons["Next"]
        nextButton.tap()
        
        app.keys["4"].tap()
        nextButton.tap()
        
        app.keys["2"].tap()
        nextButton.tap()
        
        app.keys["9"].tap()
        app.keys["4"].tap()
        app.keys["8"].tap()
        app.keys["0"].tap(
        app.keys["7"].tap())
        nextButton.tap()
        
        scrollViewsQuery.children(matching: .button).matching(identifier: "SET").element(boundBy: 0).tap()
        
        let po4TextField = app.scrollViews.children(matching: .textField).matching(identifier: "mg/L").element(boundBy: 0)
        po4TextField.tap()
        
        app.keys["7"].tap()
        nextButton.tap()
        
        app.buttons["SUBMIT"].tap()
        
        scrollViewsQuery.children(matching: .button).matching(identifier: "SET").element(boundBy: 0).tap()
        
        let totalChlTextField = app.scrollViews.children(matching: .textField).matching(identifier: "μg/L").element(boundBy: 0)
        totalChlTextField.tap()
        app.keys["4"].tap()
        app.keys["1"].tap()
        nextButton.tap()
        app.keys["8"].tap()
        app.keys["2"].tap()
        
        app.buttons["SUBMIT"].tap()
        
        app.buttons["SUBMIT"].tap()
        
    }
    
    func testEdit() {
        
        let app = XCUIApplication()
        app.tabBars.buttons["DATALOG"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts["2016-12-05"].tap()
        tablesQuery.staticTexts["15:54:14"].tap()
        app.buttons["Edit Data Set"].tap()
        app.buttons["SUBMIT"].tap()
        
    }
    
    func testDataLog() {
        
        
        let app = XCUIApplication()
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["DATALOG"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts["2016-12-05"].tap()
        tablesQuery.staticTexts["15:54:14"].tap()
        tabBarsQuery.buttons["GRAPH"].tap()
        tabBarsQuery.buttons["DATA"].tap()
        app.buttons["Data Set"].tap()
    }
    
    func testQuestion() {
        
        let app = XCUIApplication()
        let scrollViewsQuery = app.scrollViews
        scrollViewsQuery.children(matching: .button).matching(identifier: "?").element(boundBy: 0).tap()
        
        let uiviewNavigationBar = app.navigationBars["UIView"]
        let backButton = uiviewNavigationBar.children(matching: .button).matching(identifier: "Back").element(boundBy: 0)
        backButton.tap()
        scrollViewsQuery.children(matching: .button).matching(identifier: "?").element(boundBy: 1).tap()
        backButton.tap()
        scrollViewsQuery.children(matching: .button).matching(identifier: "?").element(boundBy: 2).tap()
        backButton.tap()
        scrollViewsQuery.children(matching: .button).matching(identifier: "?").element(boundBy: 3).tap()
        backButton.tap()
        scrollViewsQuery.children(matching: .button).matching(identifier: "?").element(boundBy: 4).tap()
        backButton.tap()
        
        let button = scrollViewsQuery.children(matching: .button).matching(identifier: "?").element(boundBy: 5)
        button.tap()
        backButton.tap()
        scrollViewsQuery.children(matching: .button).matching(identifier: "SET").element(boundBy: 0).tap()
        
        let button2 = app.buttons["?"]
        button2.tap()
        uiviewNavigationBar.buttons["PO4 Entry"].tap()
        app.navigationBars["PO4 Entry"].children(matching: .button).matching(identifier: "Back").element(boundBy: 0).tap()
        button.tap()
        backButton.tap()
        scrollViewsQuery.children(matching: .button).matching(identifier: "SET").element(boundBy: 1).tap()
        button2.tap()
        uiviewNavigationBar.buttons["Chl Entry"].tap()
        app.navigationBars["Chl Entry"].children(matching: .button).matching(identifier: "Back").element(boundBy: 0).tap()
        
    }
    
}
