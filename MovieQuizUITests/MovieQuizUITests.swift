//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Konstantin Kirillov on 27.11.2022.
//

import XCTest

class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app = XCUIApplication()
        app.launch()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app.terminate()
        app = nil
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testYesButton() throws {
        let firstPoster = app.images["Poster"]
        let yesButton = app.buttons["Yes"]
        let indexText = app.staticTexts["Index"].label
         
        yesButton.tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let indexTextAfter = app.staticTexts["Index"].label
        XCTAssertFalse(firstPoster == secondPoster)
        XCTAssertFalse(indexText == indexTextAfter)
    }
    
    func testNoButtonPressed() throws {
        let firstPoster = app.images["Poster"]
        let noButton = app.buttons["No"]
        
        noButton.tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let indexText = app.staticTexts["Index"].label
        XCTAssertNotEqual(firstPoster, secondPoster)
        XCTAssertTrue(indexText == "2/10")
        
    }
    
    func testShowResultAlert() throws {
        let yesButton = app.buttons["Yes"]
        
        for _ in 1...10 {
            yesButton.tap()
            sleep(1)
        }
        
        let alert = app.alerts["resultAlert"]
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть еще раз")
        XCTAssertTrue(alert.label == "Раунд окончен!")
        
    }
    
    func testAlertDismiss() throws {
        let yesButton = app.buttons["Yes"]
        
        for _ in 1...10 {
            yesButton.tap()
            sleep(1)
        }
        let alert = app.alerts["resultAlert"]
        alert.buttons.firstMatch.tap()
        sleep(1)
        
        let indexText = app.staticTexts["Index"].label
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexText == "1/10")
    }

}
