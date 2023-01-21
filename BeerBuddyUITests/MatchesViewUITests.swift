//
//  MatchesViewUITests.swift
//  BeerBuddyUITests
//
//  Created by Ke4a on 21.01.2023.
//

import XCTest

final class MatchesViewUITests: XCTestCase {
    var app: XCUIApplication!
    var viewApp: XCUIElement!

    override func setUpWithError() throws {
        try super.setUpWithError()

        app = XCUIApplication()
        app.launchArguments.append(AppUITestsLaunchArguments.matchesView)
        app.launch()
        viewApp = app.otherElements["matchesView"].firstMatch
    }

    override func tearDownWithError() throws {
        app = nil
        viewApp = nil

        try super.tearDownWithError()
    }

    func testElements() {
        let header = viewApp.otherElements["headerView"].firstMatch
        let headerRightButton = header.buttons["rightButton"].firstMatch
        let table = viewApp.tables["tableView"].firstMatch
        let tableCells = viewApp.cells["matchesTableViewCell"].firstMatch
       
        XCTAssertTrue(header.exists)
        XCTAssert(headerRightButton.exists)
        XCTAssertTrue(table.exists)
        XCTAssert(tableCells.exists)
    }
}
