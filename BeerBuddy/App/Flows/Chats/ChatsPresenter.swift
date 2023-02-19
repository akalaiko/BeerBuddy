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
    func viewToggleCellPin(_ indexPath: IndexPath) -> IndexPath
    /// Deletes cell .
    /// - Parameter indexPath: Index path.
    func viewDeleteCell(_ indexPath: IndexPath)
    /// Checks if the cell is pinned in the table.
    /// - Parameter indexPath: Index path.
    /// - Returns: If the cell is pinned, it will return true.
    func viewCheckCellIsPinned(_ indexPath: IndexPath) -> Bool
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

    private lazy var pinnedItems: [Int] = [] {
        didSet {
            updateFixationsInUserDefaults()
        }
    }
    private lazy var data: [ChatModelStub] = []

    private let dateFormatter: DateFormatterProtocol
    private let network: NetworkMockProtocol
    private lazy var userDefaults = UserDefaults.standard

    // MARK: - Initialization

    init(dateFormatter: DateFormatterProtocol, network: NetworkMockProtocol) {
        self.dateFormatter = dateFormatter
        self.network = network
    }

    // MARK: - Public Methods

    func viewRequestFetch() {
        let response = network.fetchChats()
        let distributData = distributDataFromUserdefaults(response)
        self.data = sortData(distributData)
    }

    func viewRequestCellData(_ indexPath: IndexPath) -> CellData {
        let item = data[indexPath.row]
        let dateString = dateFormatter.getString(timeIntervalSince1970: item.date)
        return (username: item.username, lastMessage: item.lastMessage, date: dateString, isPinned: item.isPinned)
    }

    func viewDeleteCell(_ indexPath: IndexPath) {
        let item = data.remove(at: indexPath.row)
        if let pinsIndex = pinnedItems.firstIndex(of: item.id) {
            pinnedItems.remove(at: pinsIndex)
        }
    }

    func viewToggleCellPin(_ indexPath: IndexPath) -> IndexPath {
        var item = data.remove(at: indexPath.row)
        item.isPinned.toggle()

        let newIndex: IndexPath
        if item.isPinned {
            newIndex = IndexPath(row: pinnedItems.count, section: 0)
            pinnedItems.append(item.id)
        } else {
            if let pinsIndex = pinnedItems.firstIndex(of: item.id) {
                pinnedItems.remove(at: pinsIndex)
            }
            guard  let index = self.data.firstIndex(where: { $0.date < item.date && !$0.isPinned }) else {
                self.data.append(item)
                return .init(row: dataCount - 1, section: 0)
            }
            newIndex = IndexPath(row: index, section: 0)
        }

        self.data.insert(item, at: newIndex.row)
        return newIndex
    }

    func viewCheckCellIsPinned(_ indexPath: IndexPath) -> Bool {
        let item = self.data[indexPath.row]
        return item.isPinned
    }

    func viewOpenScreenChat(_ indexPath: IndexPath) {
        let id = data[indexPath.row].id
        print(id)
    }

    // MARK: - Private Methods

    /// Updating the fixation data in userdefaults.
    private func updateFixationsInUserDefaults() {
        userDefaults.set(pinnedItems, forKey: "pinnedChats")
    }

    /// Recovering/distributing saved data in user defaults.
    /// - Parameter data: Data table.
    /// - Returns: A tuple with pinned data and unpinned data.
    private func distributDataFromUserdefaults(_ data: [ChatModelStub]) -> [ChatModelStub] {
        guard let pinnedChats = userDefaults.array(forKey: "pinnedChats") as? [Int] else { return data }

        var correctPins: [Int] = []
        let data = data.map { item in
            var item = item
            let isPinned = pinnedChats.contains(item.id)
            if isPinned {
                correctPins.append(item.id)
            }
            item.isPinned = isPinned
            return item
        }
        pinnedItems = pinnedChats.filter { correctPins.contains($0) }
        return data
    }

    /// Sorting by fixation and time.
    /// - Parameter data: Data.
    /// - Returns: Sorted data.
    private func sortData(_ data: [ChatModelStub]) -> [ChatModelStub] {
        return data.sorted(by: { item1, item2 in
            if item1.isPinned && item2.isPinned {
                return pinnedItems.firstIndex(of: item1.id) ?? 0 < pinnedItems.firstIndex(of: item2.id) ?? 0
            } else if item1.isPinned || item2.isPinned {
                return item1.isPinned
            }

            return  item1.date > item2.date
        })
    }
}
