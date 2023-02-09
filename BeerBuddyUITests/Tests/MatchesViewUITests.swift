//
//  MatchesViewUITests.swift
//  BeerBuddyUITests
//
//  Created by Ke4a on 21.01.2023.
//

import XCTest

final class MatchesViewUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()

        app = XCUIApplication()
        app.launchArguments.append(AppUITestsLaunchArguments.matchesView)
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
        try super.tearDownWithError()
    }

    func testElements() {
        MatchesScreen(app: app)
            .verifyElements()
    }
}
