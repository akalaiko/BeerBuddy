//
//  MatchesScreens.swift
//  BeerBuddyUITests
//
//  Created by Ke4a on 09.02.2023.
//

import XCTest

struct MatchesScreen: Screen {
    var app: XCUIApplication
    private var viewApp: XCUIElement

    private enum Identifiers {
        static let view = "matches"
        static let header = "matchesHeader"
        static let headerRightButton = "headerRightButton"
        static let tableView = "matchesTable"
        static let cell = "matchesCell"
    }

    init(app: XCUIApplication) {
        self.app = app
        self.viewApp = app.otherElements[Identifiers.view].firstMatch
    }

    func verifyElements() {
        let header = viewApp.otherElements[Identifiers.header].firstMatch
        let headerRightButton = header.buttons[Identifiers.headerRightButton].firstMatch
        let table = viewApp.tables[Identifiers.tableView].firstMatch
        let tableCells = viewApp.cells[Identifiers.cell].firstMatch

        XCTAssertTrue(header.isHittable)
        XCTAssertTrue(headerRightButton.isHittable)
        XCTAssertTrue(table.isHittable)
        XCTAssertTrue(tableCells.isHittable)
    }
}
