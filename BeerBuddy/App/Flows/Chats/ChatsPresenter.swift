//
//  ChatsPresenter.swift
//  BeerBuddy
//
//  Created by Ke4a on 04.02.2023.
//

import UIKit

protocol ChatsViewInput: AnyObject {
    var loginObserver: NSObjectProtocol? { get }
}

protocol ChatsViewOutput: AnyObject {
    typealias CellData = (email: String, username: String, lastMessage: String, date: String, isPinned: Bool)
    /// Quantity of cell to build the table.
    var dataCount: Int { get }
    /// Requesting data from the network.
    func startListeningForConversations()
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

    weak var viewInput: (UIViewController & ChatsViewInput)?

    // MARK: - Private Properties

    private lazy var pinnedItems: [String] = [] {
        didSet {
            updateFixationsInUserDefaults()
        }
    }
    private lazy var data: [Conversation] = []

//    private let dateFormatter: DateFormatterProtocol
//    private let network: NetworkMockProtocol
//    private lazy var userDefaults = UserDefaults.standard

    // MARK: - Initialization

//    init(dateFormatter: DateFormatterProtocol, network: NetworkMockProtocol) {
//        self.dateFormatter = dateFormatter
//        self.network = network
//    }

    // MARK: - Public Methods

//    func viewRequestFetch() {
//        
//        startListeningForConversations()
//        let response = network.fetchChats()
//        let distributData = distributDataFromUserdefaults(response)
//        self.data = sortData(distributData)
//    }
    
    func startListeningForConversations() {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else { return }

        if let loginObserver = viewInput?.loginObserver {
            NotificationCenter.default.removeObserver(loginObserver)
        }
        
        let safeEmail = DatabaseManager.safeEmail(email: email)
        print("we are here, safe email is:", safeEmail)
        DatabaseManager.shared.getAllConversations(for: safeEmail, completion: { [weak self] result in
            switch result {
            case .success(let fetchedConversations):
                guard !fetchedConversations.isEmpty else { return }
//                guard let distributData = self?.distributDataFromUserdefaults(fetchedConversations) else { return }
                self?.data = fetchedConversations
                
                DispatchQueue.main.async {
                    self?.viewInput?.view.reloadInputViews()
                }
            case .failure(let error):
                print("listen", error)
            }
        })
    }

    func viewRequestCellData(_ indexPath: IndexPath) -> CellData {
        
        let item = data[indexPath.row]
        return (email: item.otherUserEmail,
                username: item.name,
                lastMessage: item.latestMessage.text,
                date: item.latestMessage.date,
                isPinned: item.isPinned)
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
            guard  let index = self.data.firstIndex(where: {
                $0.latestMessage.date < item.latestMessage.date && !$0.isPinned }) else {
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

    // MARK: - Private Methods

    /// Updating the fixation data in userdefaults.
    private func updateFixationsInUserDefaults() {
        UserDefaults.standard.set(pinnedItems, forKey: "pinnedChats")
    }

    /// Recovering/distributing saved data in user defaults.
    /// - Parameter data: Data table.
    /// - Returns: A tuple with pinned data and unpinned data.
    private func distributDataFromUserdefaults(_ data: [Conversation]) -> [Conversation] {
        guard let pinnedChats = UserDefaults.standard.array(forKey: "pinnedChats") as? [String] else { return data }

        var correctPins: [String] = []
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
    private func sortData(_ data: [Conversation]) -> [Conversation] {
        return data.sorted(by: { item1, item2 in
            if item1.isPinned && item2.isPinned {
                return pinnedItems.firstIndex(of: item1.id) ?? 0 < pinnedItems.firstIndex(of: item2.id) ?? 0
            } else if item1.isPinned || item2.isPinned {
                return item1.isPinned
            }

            return  item1.latestMessage.date > item2.latestMessage.date
        })
    }
    
    func viewOpenScreenChat(_ indexPath: IndexPath) {
        let conversation = data[indexPath.row]
        let vc = ChatViewController(with: conversation.otherUserEmail, id: conversation.id)
        let nav = UINavigationController(rootViewController: vc)
        vc.isNewConversation = false
        vc.title = conversation.name
        nav.isNavigationBarHidden = false
        viewInput?.present(nav, animated: true)
    }
}
