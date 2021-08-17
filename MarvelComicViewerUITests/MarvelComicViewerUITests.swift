//
//  MarvelComicViewerUITests.swift
//  MarvelComicViewerUITests
//
//  Created by Kieran Barry on 8/13/21.
//

import XCTest

/// UI Tests for MarvelComicViewer app
class MarvelComicViewerUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
    }

    /// Tests that all data associated with comic (id = 52646) is loaded into display
    func testDisplaysAllInformation() throws {
        let app = XCUIApplication()
        XCTAssertTrue(app.staticTexts[Constants.AccessibilityIdentifiers.comicTitle.rawValue].waitForExistence(timeout: 5))
        XCTAssertEqual(app.staticTexts[Constants.AccessibilityIdentifiers.comicTitle.rawValue].label, "STAR WARS VOL. 2: SHOWDOWN ON THE SMUGGLER'S MOON")
        XCTAssertEqual(app.staticTexts[Constants.AccessibilityIdentifiers.comicIssueNumber.rawValue].label, "Issue: 2")
        XCTAssertEqual(app.staticTexts[Constants.AccessibilityIdentifiers.comicAuthors.rawValue].label,
                       "By: Jason Aaron, Simone Bianchi, John Cassaday, Stuart Immonen, Chris Eliopoulos, Wade Von Grawbadger, Laura Martin, Justin Ponsor, and Jeff Youngquist")
        XCTAssertEqual(app.staticTexts[Constants.AccessibilityIdentifiers.comicDescription.rawValue].label,
                       "Injustice reigns on Tatooine as villainous scum run rampant. Will Ben Kenobi risk revealing himself to do what's right? Then, Luke continues his quest to learn about the Jedi by heading for the Jedi Temple on Coruscant. Plus: Han & Leia are confronted by an unexpected foe from Han's past! COLLECTING: STAR WARS (2015)#7-12.")
//        if let textViewValue = app.textViews[Constants.AccessibilityIdentifiers.comicDescription.rawValue].value as? String {
//            XCTAssertEqual(textViewValue,
//                           "Injustice reigns on Tatooine as villainous scum run rampant. Will Ben Kenobi risk revealing himself to do what's right? Then, Luke continues his quest to learn about the Jedi by heading for the Jedi Temple on Coruscant. Plus: Han & Leia are confronted by an unexpected foe from Han's past! COLLECTING: STAR WARS (2015)#7-12.")
//        } else {
//            XCTFail("No description text string found")
//        }
        XCTAssert(app.images[Constants.AccessibilityIdentifiers.comicImage.rawValue].exists)
    }

}
