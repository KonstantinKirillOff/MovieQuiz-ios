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
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
        app = nil
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
