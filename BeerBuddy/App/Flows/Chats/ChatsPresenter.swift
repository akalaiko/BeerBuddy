//
//  ChatsPresenter.swift
//  BeerBuddy
//
//  Created by Ke4a on 04.02.2023.
//

import Foundation

protocol ChatsViewInput: AnyObject {

}

protocol ChatsViewOutput: AnyObject {
    typealias CellData = (username: String, lastMessage: String, date: String, isPinned: Bool)
    /// Quantity of cell to build the table.
    var dataCount: Int { get }
    /// Requesting data from the network.
    func viewRequestFetch()
    /// Getting cell data by index.
    /// - Parameter indexPath: Index path.
    /// - Returns: Data for cell configuration.
    func viewRequestCellData(_ indexPath: IndexPath) -> CellData
    /// Pins the cell from the table.
    /// - Parameter indexPath: Index path.
    /// - Returns: New cell index in the table.
    func viewPinCell(_ indexPath: IndexPath) -> IndexPath
    /// Unpins the cell from the table.
    /// - Parameter indexPath: Index path.
    /// - Returns: New cell index in the table.
    func viewUnpinCell(_ indexPath: IndexPath) -> IndexPath
    /// Deletes cell .
    /// - Parameter indexPath: Index path.
    func viewDeleteCell(_ indexPath: IndexPath)
    /// Checks if the cell is pinned in the table.
    /// - Parameter indexPath: Index path.
    /// - Returns: If the cell is pinned, it will return true.
    func viewCheckCellIsPin(_ indexPath: IndexPath) -> Bool
    /// Open the chat screen.
    /// - Parameter indexPath: Index path.
    func viewOpenScreenChat(_ indexPath: IndexPath)
}

class ChatsPresenter: ChatsViewOutput {
    // MARK: - Public Properties

    var dataCount: Int {
        data.count
    }

    weak var viewInput: ChatsViewInput?

    // MARK: - Private Properties

    private var pinnedData: [ChatModelTest] = [] {
        didSet {
            updatePinsInUserDefaults()
        }
    }

    private var unpinnedData: [ChatModelTest] = []

    private var data: [ChatModelTest] {
        pinnedData + unpinnedData
    }

    private let dateFormatter: DateFormatterProtocol
    private lazy var userDefaults = UserDefaults.standard

    // MARK: - Initialization

    init(dateFormatter: DateFormatterProtocol) {
        self.dateFormatter = dateFormatter
    }

    // MARK: - Public Methods

    func viewRequestFetch() {
        let distributedData = distributDataFromUserdefaults(ChatModelTest.testData)
        self.unpinnedData = distributedData.unpinnedData
        self.pinnedData = distributedData.pinnedData
    }

    func viewRequestCellData(_ indexPath: IndexPath) -> CellData {
        let data = data[indexPath.row]
        let dateString = dateFormatter.getString(timeIntervalSince1970: data.date)
        let isPinned = viewCheckCellIsPin(indexPath)
        return (username: data.username, lastMessage: data.lastMessage, date: dateString, isPinned: isPinned)
    }

    func viewDeleteCell(_ indexPath: IndexPath) {
        if pinnedData.count > indexPath.row {
            pinnedData.remove(at: indexPath.row)
        } else {
            unpinnedData.remove(at: indexPath.row - pinnedData.count)
        }
    }

    func viewPinCell(_ indexPath: IndexPath) -> IndexPath {
        let data = unpinnedData.remove(at: indexPath.row - pinnedData.count)
        pinnedData.append(data)
        return IndexPath(row: pinnedData.count - 1, section: 0)
    }

    func viewUnpinCell(_ indexPath: IndexPath) -> IndexPath {
        let data = pinnedData.remove(at: indexPath.row)

        guard  let index = unpinnedData.firstIndex(where: { $0.date < data.date }) else {
            unpinnedData.append(data)
            return .init(row: dataCount - 1, section: 0)
        }

        unpinnedData.insert(data, at: index)
        return IndexPath(row: pinnedData.count + index, section: 0)
    }

    func viewCheckCellIsPin(_ indexPath: IndexPath) -> Bool {
        pinnedData.count > indexPath.row
    }

    func viewOpenScreenChat(_ indexPath: IndexPath) {
        let data: ChatModelTest

        if pinnedData.count > indexPath.row {
            data = pinnedData [indexPath.row]
        } else {
            data = unpinnedData [indexPath.row - pinnedData.count]
        }

        print(data.id)
    }

    // MARK: - Private Methods

    /// Updating the fixation data in userdefaults.
    private func updatePinsInUserDefaults() {
        let newPins = pinnedData.map { $0.id }
        userDefaults.set(newPins, forKey: "pinnedChats")
    }

    /// Recovering/distributing saved data in user defaults.
    /// - Parameter data: Data table.
    /// - Returns: A tuple with pinned data and unpinned data.
    private func distributDataFromUserdefaults(_ data: [ChatModelTest]) -> (unpinnedData: [ChatModelTest],
                                                                            pinnedData: [ChatModelTest]) {
        var response = ChatModelTest.testData.sorted(by: { $0.date > $1.date })
        var pinArray: [ChatModelTest] = []
        let pinnedIdArray = (userDefaults.array(forKey: "pinnedChats") as? [Int] ?? []).filter { pinId in
            guard let index = response.firstIndex(where: { $0.id == pinId }) else { return false }
            pinArray.append(response.remove(at: index))

            return true
        }

        return (unpinnedData: response, pinnedData: pinArray)
    }
}

// FIXME: Only for tests, remove after connecting firebase.

struct ChatModelTest {
    let id: Int
    let username: String = UserTest.names.randomElement() ?? "Error name"
    let lastMessage: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit," +
    "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
    let date: Double

    static var testData: [ChatModelTest] {
        let now = Date()
        return [ .init(id: 0,
                       date: Date().timeIntervalSince1970),
                 .init(id: 1,
                       date: Calendar.current.date(byAdding: .second,
                                                   value: -10, to: now)!.timeIntervalSince1970),
                 .init(id: 2,
                       date: Calendar.current.date(byAdding: .minute,
                                                   value: -Int.random(in: 1...100), to: now)!.timeIntervalSince1970),
                 .init(id: 3,
                       date: Calendar.current.date(byAdding: .minute,
                                                   value: -Int.random(in: 500...1000), to: now)!.timeIntervalSince1970),
                 .init(id: 4,
                       date: Calendar.current.date(byAdding: .hour,
                                                   value: -Int.random(in: 12...16), to: now)!.timeIntervalSince1970),
                 .init(id: 5,
                       date: Calendar.current.date(byAdding: .hour,
                                                   value: -Int.random(in: 16...24), to: now)!.timeIntervalSince1970),
                 .init(id: 6,
                       date: Calendar.current.date(byAdding: .day,
                                                   value: -Int.random(in: 2...6), to: now)!.timeIntervalSince1970),
                 .init(id: 7,
                       date: Calendar.current.date(byAdding: .day,
                                                   value: -Int.random(in: 6...12), to: now)!.timeIntervalSince1970),
                 .init(id: 8,
                       date: Calendar.current.date(byAdding: .day,
                                                   value: -Int.random(in: 12...24), to: now)!.timeIntervalSince1970),
                 .init(id: 9,
                       date: Calendar.current.date(byAdding: .minute,
                                                   value: -Int.random(in: 60...500), to: now)!.timeIntervalSince1970),
                 .init(id: 10,
                       date: Calendar.current.date(byAdding: .minute,
                                                   value: -Int.random(in: 500...1000), to: now)!.timeIntervalSince1970),
                 .init(id: 11,
                       date: Calendar.current.date(byAdding: .hour,
                                                   value: -Int.random(in: 12...16), to: now)!.timeIntervalSince1970),
                 .init(id: 12,
                       date: Calendar.current.date(byAdding: .hour,
                                                   value: -Int.random(in: 16...24), to: now)!.timeIntervalSince1970),
                 .init(id: 13,
                       date: Calendar.current.date(byAdding: .day,
                                                   value: -Int.random(in: 2...6), to: now)!.timeIntervalSince1970),
                 .init(id: 14,
                       date: Calendar.current.date(byAdding: .day,
                                                   value: -Int.random(in: 6...12), to: now)!.timeIntervalSince1970),
                 .init(id: 15,
                       date: Calendar.current.date(byAdding: .day,
                                                   value: -Int.random(in: 12...24), to: now)!.timeIntervalSince1970),
                 .init(id: 16,
                       date: Calendar.current.date(byAdding: .minute,
                                                   value: -Int.random(in: 60...500), to: now)!.timeIntervalSince1970),
                 .init(id: 17,
                       date: Calendar.current.date(byAdding: .minute,
                                                   value: -Int.random(in: 500...1000), to: now)!.timeIntervalSince1970),
                 .init(id: 18,
                       date: Calendar.current.date(byAdding: .hour,
                                                   value: -Int.random(in: 12...16), to: now)!.timeIntervalSince1970),
                 .init(id: 19,
                       date: Calendar.current.date(byAdding: .hour,
                                                   value: -Int.random(in: 16...24), to: now)!.timeIntervalSince1970),
                 .init(id: 20,
                       date: Calendar.current.date(byAdding: .day,
                                                   value: -Int.random(in: 2...6), to: now)!.timeIntervalSince1970),
                 .init(id: 21,
                       date: Calendar.current.date(byAdding: .day,
                                                   value: -Int.random(in: 6...12), to: now)!.timeIntervalSince1970),
                 .init(id: 22,
                       date: Calendar.current.date(byAdding: .day,
                                                   value: -Int.random(in: 12...24), to: now)!.timeIntervalSince1970),
                 .init(id: 23,
                       date: Calendar.current.date(byAdding: .minute,
                                                   value: -Int.random(in: 60...500), to: now)!.timeIntervalSince1970),
                 .init(id: 24,
                       date: Calendar.current.date(byAdding: .minute,
                                                   value: -Int.random(in: 500...1000), to: now)!.timeIntervalSince1970),
                 .init(id: 25,
                       date: Calendar.current.date(byAdding: .hour,
                                                   value: -Int.random(in: 12...16), to: now)!.timeIntervalSince1970),
                 .init(id: 26,
                       date: Calendar.current.date(byAdding: .hour,
                                                   value: -Int.random(in: 16...24), to: now)!.timeIntervalSince1970),
                 .init(id: 27,
                       date: Calendar.current.date(byAdding: .day,
                                                   value: -Int.random(in: 2...6), to: now)!.timeIntervalSince1970),
                 .init(id: 28,
                       date: Calendar.current.date(byAdding: .day,
                                                   value: -Int.random(in: 6...12), to: now)!.timeIntervalSince1970),
                 .init(id: 29,
                       date: Calendar.current.date(byAdding: .day,
                                                   value: -Int.random(in: 12...24), to: now)!.timeIntervalSince1970),
                 .init(id: 30,
                       date: Calendar.current.date(byAdding: .minute,
                                                   value: -Int.random(in: 60...500), to: now)!.timeIntervalSince1970),
                 .init(id: 31,
                       date: Calendar.current.date(byAdding: .minute,
                                                   value: -Int.random(in: 500...1000), to: now)!.timeIntervalSince1970),
                 .init(id: 32,
                       date: Calendar.current.date(byAdding: .hour,
                                                   value: -Int.random(in: 12...16), to: now)!.timeIntervalSince1970),
                 .init(id: 33,
                       date: Calendar.current.date(byAdding: .hour,
                                                   value: -Int.random(in: 16...24), to: now)!.timeIntervalSince1970),
                 .init(id: 34,
                       date: Calendar.current.date(byAdding: .day,
                                                   value: -Int.random(in: 2...6), to: now)!.timeIntervalSince1970),
                 .init(id: 35,
                       date: Calendar.current.date(byAdding: .day,
                                                   value: -Int.random(in: 6...12), to: now)!.timeIntervalSince1970),
                 .init(id: 36,
                       date: Calendar.current.date(byAdding: .day,
                                                   value: -Int.random(in: 12...24), to: now)!.timeIntervalSince1970)]
    }
}
