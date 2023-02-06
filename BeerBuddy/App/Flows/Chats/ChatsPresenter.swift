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

    private var pinnedData: [ChatModelStub] = [] {
        didSet {
            updatePinsInUserDefaults()
        }
    }

    private var unpinnedData: [ChatModelStub] = []

    private var data: [ChatModelStub] {
        pinnedData + unpinnedData
    }

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
        let distributedData = distributDataFromUserdefaults(response)
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
        let data: ChatModelStub

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
    private func distributDataFromUserdefaults(_ data: [ChatModelStub]) -> (unpinnedData: [ChatModelStub],
                                                                            pinnedData: [ChatModelStub]) {
        var unpinned = data.sorted(by: { $0.date > $1.date })
        var pinned: [ChatModelStub] = []

        if let userDefaultsData = userDefaults.array(forKey: "pinnedChats") as? [Int] {
            userDefaultsData.forEach { pinId in
                guard let index = unpinned.firstIndex(where: { $0.id == pinId }) else { return }
                pinned.append(unpinned.remove(at: index))
            }
        }

        return (unpinnedData: unpinned, pinnedData: pinned)
    }
}
