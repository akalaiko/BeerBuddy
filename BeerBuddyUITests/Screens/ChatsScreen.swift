//
//  ChatsScreen.swift
//  BeerBuddyUITests
//
//  Created by Ke4a on 09.02.2023.
//

import XCTest
extension ChatsScreen {
    /// Screen component identifiers
    private enum Identifiers {
        static let view = "chats"
        static let header = "chatsHeader"
        static let headerRightButton = "headerRightButton"
        static let tableView = "chatsTable"
        static let pinImage = "cellPinImage"
        static let cell = "chatsCell"
        static let pinnedCell = "chatsPinnedCell"
        static let date = "cellDate"
    }
}

struct ChatsScreen: Screen {
    // MARK: - Public Properties

    /// Count of cells in the table.
    var cellCount: Int {
        table.cells.count
    }

    // MARK: - Private Properties

    private(set) var app: XCUIApplication
    private var view: XCUIElement
    private var table: XCUIElement

    // MARK: - Initialization

    init(app: XCUIApplication) {
        self.app = app
        self.view = app.otherElements[Identifiers.view].firstMatch
        self.table = view.tables[Identifiers.tableView].firstMatch
    }

    // MARK: - Public Methods
    
    /// Retrieves the text representation of a date based on an index value.
    /// - Parameter index: The index of the cell for which you want to get the text.
    /// - Returns: String date of the selected cell.
    func getDateText(_ index: Int) -> String {
        let selectedCell = table.cells.element(boundBy: index).firstMatch
        return selectedCell.staticTexts[Identifiers.date].firstMatch.label
    }

    /// Checks the elements on the screen.
    func verifyElements() {
        let header = view.otherElements[Identifiers.header].firstMatch
        let headerRightButton = header.buttons[Identifiers.headerRightButton].firstMatch
        let table = table
        let tableCells = table.cells[Identifiers.cell].firstMatch
        
        XCTAssertTrue(header.isHittable)
        XCTAssertFalse(headerRightButton.exists)
        XCTAssertTrue(table.isHittable)
        XCTAssertTrue(tableCells.isHittable)
    }

    /// Performs  right swipe gesture on a cell. The cell must be visible on the screen.
    /// - Parameter index: The index  of the cell to be swiped.
    /// - Returns: Returns the screen manager.
    func rightSwipeTap(_ index: Int) -> Self {
        let selectedCell = table.cells.element(boundBy: index).firstMatch
        selectedCell.swipeRight()
        selectedCell.buttons.firstMatch.tap()
        return self
    }

    /// Performs  left swipe gesture on a cell. The cell must be visible on the screen.
    /// - Parameter index: The index  of the cell to be swiped.
    /// - Returns: Returns the screen manager
    func leftSwipeTap(_ index: Int) -> Self {
        let selectedCell = table.cells.element(boundBy: index).firstMatch
        selectedCell.swipeLeft()
        selectedCell.buttons.firstMatch.tap()
        return self
    }

    /// Performs a swipe gesture on a specific cell in a table view.
    /// - Parameter index: The index of the cell to which you want to scroll.
    /// - Returns: Returns the screen manager
    func scrollToCell(_ index: Int) -> Self {
        let selectedCell = table.cells.element(boundBy: index).firstMatch

        guard !selectedCell.isHittable,
              let firstVisableIndex = table.cells.allElementsBoundByIndex.firstIndex(where: { $0.isHittable })
        else { return self }

        var loppFailCount = 5
        while !selectedCell.isHittable {
            if loppFailCount < 0 {
                XCTFail("loop error")
                return self
            } else if firstVisableIndex > index {
                table.swipeDown()
            } else {
                table.swipeUp()
            }

            loppFailCount -= 1
        }

        return self
    }

    ///  Verifies the number of pinned cells in a table view.
    /// - Parameter count: The expected number of pinned cells.
    func verifyPinnedCell(_ count: Int) {
        let pinnedCellCount = table.cells.containing(NSPredicate(format: "identifier == %@",
                                                                 Identifiers.pinnedCell)).count
        XCTAssertEqual(count, pinnedCellCount)
        
        for i in 0..<pinnedCellCount {
            let cell = table.cells.element(boundBy: i)
            if cell.isHittable {
                XCTAssertTrue(cell.isHittable)
                XCTAssertTrue(cell.identifier == Identifiers.pinnedCell)
                XCTAssertTrue(cell.images[Identifiers.pinImage].firstMatch.isHittable)
            } else {
                XCTAssertTrue(cell.exists)
                XCTAssertTrue(cell.identifier == Identifiers.pinnedCell)
                XCTAssertTrue(cell.images[Identifiers.pinImage].firstMatch.exists)
            }
        }
    }

    ///  Verifies the number of  cells in a table view.
    /// - Parameter count: The expected number of cells.
    func verifyCountCell(_ count: Int) {
        let cellCount = table.cells.containing(NSPredicate(format: "identifier CONTAINS %@",
                                                           Identifiers.cell)).count
        XCTAssertEqual(count, cellCount)
    }

    /// Verifies the text of a specific cell in a table view.
    /// - Parameters:
    ///   - text: The expected text of the cell.
    ///   - index: The index of the cell to be verified.
    func verifyTextCell(_ text: String, _ index: Int) {
        XCTAssertEqual(text, getDateText(index))
    }
}
