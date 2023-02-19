//
//  ChatsPresenterTests.swift
//  BeerBuddyTests
//
//  Created by Ke4a on 06.02.2023.
//

@testable import BeerBuddy
import XCTest

final class ChatsPresenterTests: XCTestCase {
    var presenter: ChatsPresenter!

    override func setUp() {
        super.setUp()
        clearUserDefaults()

        let dF = DateFormatterHelper()
        let networkMock = NetworkMockForTests()
        presenter = ChatsPresenter(dateFormatter: dF, network: networkMock)
    }

    override func tearDown() {
        presenter = nil
        super.tearDown()
    }

    func testFetch() {
        XCTAssertEqual(presenter.dataCount, 0)
        presenter.viewRequestFetch()

        let checkCount = NetworkMockForTests().fetchChats().count
        XCTAssertEqual(checkCount, presenter.dataCount)
    }

    func testPinUnpinCell() {
        presenter.viewRequestFetch()

        for i in 0..<presenter.dataCount {
            let data = presenter.viewRequestCellData(.init(row: i, section: 0))
            XCTAssertFalse(data.isPinned)
        }

        let unpinIndexUser1: IndexPath = .init(row: 0, section: 0)
        let unpinIndexUser2: IndexPath = .init(row: 5, section: 0)

        let unpinnedUser1 = presenter.viewRequestCellData(unpinIndexUser1)
        let unpinnedUser2 = presenter.viewRequestCellData(unpinIndexUser2)

        let pinIndexUser1 = presenter.viewToggleCellPin(unpinIndexUser1)
        let pinIndexUser2 = presenter.viewToggleCellPin(unpinIndexUser2)

        let pinnedUser1 = presenter.viewRequestCellData(pinIndexUser1)
        let pinnedUser2 = presenter.viewRequestCellData(pinIndexUser2)

        XCTAssertEqual(unpinnedUser1.username, pinnedUser1.username)
        XCTAssertEqual(unpinnedUser2.username, pinnedUser2.username)
        XCTAssertTrue(pinnedUser1.isPinned)
        XCTAssertTrue(pinnedUser2.isPinned)

        let newUnpinIndexUser2 = presenter.viewToggleCellPin(pinIndexUser2)
        let newUnpinIndexUser1 = presenter.viewToggleCellPin(pinIndexUser1)

        XCTAssertEqual(unpinIndexUser2, newUnpinIndexUser2)
        XCTAssertEqual(unpinIndexUser1, newUnpinIndexUser1)

        let newpinnedUser1 = presenter.viewRequestCellData(newUnpinIndexUser1)
        let newpinnedUser2 = presenter.viewRequestCellData(newUnpinIndexUser2)

        XCTAssertEqual(newpinnedUser1.username, pinnedUser1.username)
        XCTAssertEqual(newpinnedUser2.username, pinnedUser2.username)
        XCTAssertFalse(newpinnedUser1.isPinned)
        XCTAssertFalse(newpinnedUser1.isPinned)
    }

    func testDeleteCell() {
        presenter.viewRequestFetch()

        let dataCount = presenter.dataCount
        let iterations = Int.random(in: 4...dataCount)
        for _ in 0..<iterations {
            presenter.viewDeleteCell(.init(row: 0, section: 0))
        }

        XCTAssertEqual(dataCount - iterations, presenter.dataCount)
    }

    func clearUserDefaults() {
        let dictionary = UserDefaults.standard.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            UserDefaults.standard.removeObject(forKey: key)
        }
        UserDefaults.standard.synchronize()
    }
}
