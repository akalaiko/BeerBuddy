//
//  ChatsViewUITests.swift
//  BeerBuddyUITests
//
//  Created by Ke4a on 09.02.2023.
//

import XCTest

final class ChatsViewUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()

        app = XCUIApplication()
        app.launchArguments.append(AppUITestsLaunchArguments.chatsView)
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
        try super.tearDownWithError()
    }

    func testElements() {
        ChatsScreen(app: app)
            .verifyElements()
    }

    func testPinCell() {
        let screen = ChatsScreen(app: app)

        screen
            .leftSwipeTap(2)
            .leftSwipeTap(5)
            .scrollToCell(screen.cellCount - 1)
            .leftSwipeTap(screen.cellCount - 1)
            .scrollToCell(0)
            .verifyPinnedCell(3)

        screen
            .leftSwipeTap(2)
            .leftSwipeTap(1)
            .leftSwipeTap(0)
            .verifyPinnedCell(0)

        screen
            .leftSwipeTap(4)
            .rightSwipeTap(0)
            .leftSwipeTap(1)
            .leftSwipeTap(3)
            .leftSwipeTap(1)
            .leftSwipeTap(0)
            .verifyPinnedCell(0)
    }

    func testDeleteCell() {
        let screen = ChatsScreen(app: app)
        let startCountCell = screen.cellCount

        screen
            .scrollToCell(screen.cellCount - 1)
            .rightSwipeTap(screen.cellCount - 1)
            .scrollToCell(5)
            .rightSwipeTap(5)
            .scrollToCell(2)
            .rightSwipeTap(2)
            .verifyCountCell(startCountCell - 3)

        screen
            .scrollToCell(0)
            .rightSwipeTap(0)
            .rightSwipeTap(0)
            .rightSwipeTap(0)
            .verifyCountCell(startCountCell - 6)

        screen
            .leftSwipeTap(0)
            .leftSwipeTap(1)
            .rightSwipeTap(0)
            .rightSwipeTap(0)
            .rightSwipeTap(0)
            .verifyCountCell(startCountCell - 9)
    }

    func testSortCell() {
        let screen = ChatsScreen(app: app)
        let lastIndex = screen.cellCount - 1

        let dateSelectedCell1 = screen.getDateText(lastIndex - 1)
        let dateSelectedCell2 = screen.getDateText(lastIndex)
        
        screen
            .scrollToCell(lastIndex - 1)
            .leftSwipeTap(lastIndex - 1)
            .scrollToCell(0)
            .verifyTextCell(dateSelectedCell1, 0)

        screen
            .scrollToCell(lastIndex)
            .leftSwipeTap(lastIndex)
            .scrollToCell(0)
            .verifyTextCell(dateSelectedCell2, 1)

        screen
            .leftSwipeTap(0)
            .leftSwipeTap(0)
            .scrollToCell(lastIndex)
            .verifyTextCell(dateSelectedCell1, lastIndex - 1)

        screen
            .verifyTextCell(dateSelectedCell2, lastIndex)
    }
}
