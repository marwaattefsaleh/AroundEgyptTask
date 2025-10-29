//
//  ExperienceDetailsViewUITests.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 29/10/2025.
//

import XCTest

final class ExperienceDetailsViewUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--UITestMode") // optional: inject mock data
        app.launch()
        
        // Navigate to a detail view first
        let firstCell = app.scrollViews.otherElements["recommendedCell_0"]

        XCTAssertTrue(firstCell.waitForExistence(timeout: 20))
        firstCell.tap()
        
        // Wait for details view to appear
        let descriptionText = app.staticTexts["descriptionLabel"]
        XCTAssertTrue(descriptionText.waitForExistence(timeout: 10))
    }

    // MARK: - Tests

    func testDetailsView_displaysAllContent() throws {
        XCTAssertTrue(app.staticTexts["descriptionLabel"].exists)
        XCTAssertTrue(app.staticTexts["titleLabel"].exists)
        XCTAssertTrue(app.staticTexts["cityLabel"].exists)
        XCTAssertTrue(app.buttons["exploreButton"].exists)
        XCTAssertTrue(app.buttons["likeButton"].exists)
    }

    func testDetailsView_likeButtonWorks() throws {
        let likeButton = app.buttons["likeButton"]
        XCTAssertTrue(likeButton.exists)
        likeButton.tap()
        
        // Optionally verify likes label updates
        let likesLabel = app.staticTexts["likesLabel"]
        XCTAssertTrue(likesLabel.exists)
    }

    func testDetailsView_exploreButtonExists() throws {
        let exploreButton = app.buttons["exploreButton"]
        XCTAssertTrue(exploreButton.exists)
    }

    func testDetailsView_scrollContent() throws {
        let scrollView = app.scrollViews["detailsScrollView"]
        XCTAssertTrue(scrollView.exists)
        
        scrollView.swipeUp()
        scrollView.swipeDown()
    }
}
