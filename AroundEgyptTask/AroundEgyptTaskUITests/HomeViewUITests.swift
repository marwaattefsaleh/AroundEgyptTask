//
//  HomeViewUITests.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 29/10/2025.
//

import XCTest

final class HomeViewUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--UITestMode") // Optional: allows injecting mock data
        app.launch()
    }

    // MARK: - Tests

    func testHomeView_displaysWelcomeText() throws {
        XCTAssertTrue(app.staticTexts["Welcome!"].exists)
        XCTAssertTrue(app.staticTexts["Now you can explore any experience in 360 degrees and get all the details about it all in one place."].exists)
    }

    func testHomeView_searchFieldTyping() throws {
        let searchField = app.textFields["searchTextField"]
        XCTAssertTrue(searchField.exists)
        
        searchField.tap()
        searchField.typeText("Luxor")
        
        XCTAssertEqual(searchField.value as? String, "Luxor")
    }

    func testHomeView_tapFilterButton() throws {
        let filterButton = app.buttons["filterButton"]
        XCTAssertTrue(filterButton.exists)
        
        filterButton.tap()
        // Optional: verify that filter sheet/view appears
    }

    func testHomeView_clearSearchText() throws {
        let searchField = app.textFields["searchTextField"]
        searchField.tap()
        searchField.typeText("Luxor")
        
        let clearButton = app.buttons["clearSearchButton"] // Add accessibilityIdentifier in view
        XCTAssertTrue(clearButton.exists)
        clearButton.tap()
        
        XCTAssertEqual(searchField.value as? String, "Try “Luxor”")
    }

    func testHomeView_scrollAndRefresh() throws {
        let scrollView = app.scrollViews.element(boundBy: 0)
        XCTAssertTrue(scrollView.exists)
        
        scrollView.swipeDown() // triggers refresh
    }
}
