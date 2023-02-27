//
//  ChatsPresenter.swift
//  BeerBuddy
//
//  Created by Ke4a on 04.02.2023.
//

import UIKit

protocol ChatsViewInput: AnyObject {
    var loginObserver: NSObjectProtocol? { get }
    func reloadRow(_ index: IndexPath)
}

protocol ChatsViewOutput: AnyObject {
    var data: [ChatsCellModel] { get }
    /// Requesting data from the network.
    func startListeningForConversations()
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
    func viewRequestImage(_ indexPath: IndexPath)
}

class ChatsPresenter: ChatsViewOutput {
    // MARK: - Public Properties

    weak var viewInput: (UIViewController & ChatsViewInput)?

    // MARK: - Private Properties

    private lazy var pinnedItems: [String] = [] {
        didSet {
            updateFixationsInUserDefaults()
        }
    }
    private(set) lazy var data: [ChatsCellModel] = []

    //    private let dateFormatter: DateFormatterProtocol
    //    private let network: NetworkMockProtocol
    //    private lazy var userDefaults = UserDefaults.standard

    // MARK: - Initialization

    //    init(dateFormatter: DateFormatterProtocol, network: NetworkMockProtocol) {
    //        self.dateFormatter = dateFormatter
    //        self.network = network
    //    }

    private let network: NetworkProtocol

    init(network: NetworkProtocol) {
        self.network = network
    }

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
        
        let safeEmail = network.safeEmail(email: email)
        print("we are here, safe email is:", safeEmail)
        network.getAllConversations(for: safeEmail, completion: { [weak self] result in
            switch result {
            case .success(let fetchedConversations):
                guard !fetchedConversations.isEmpty else { return }
                //                guard let distributData = self?.distributDataFromUserdefaults(fetchedConversations) else { return }
                self?.data = fetchedConversations.map({ ChatsCellModel(id: $0.id,
                                                                           email: $0.otherUserEmail,
                                                                           username: $0.name,
                                                                           lastMessage: $0.latestMessage.text,
                                                                           date: $0.latestMessage.date,
                                                                           isPinned: $0.isPinned)})
                
                DispatchQueue.main.async {
                    self?.viewInput?.view.reloadInputViews()
                }
            case .failure(let error):
                print("listen", error)
            }
        })
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
                $0.date < item.date && !$0.isPinned }) else {
                self.data.append(item)
                return .init(row: data.count - 1, section: 0)
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
        let vc = ChatViewController(with: conversation.email, id: conversation.id, network: network)
        let nav = UINavigationController(rootViewController: vc)
        vc.isNewConversation = false
        vc.title = conversation.username
        nav.isNavigationBarHidden = false
        viewInput?.present(nav, animated: true)
    }

    func viewRequestImage(_ indexPath: IndexPath) {
        DispatchQueue.global().async {
            let path = self.network.getProfilePicturePath(email: self.data[indexPath.row].email)
            StorageManager.shared.downloadURL(for: path) { [weak self] result in
                switch result {
                case .success(let urlString):
                    guard let url = URL(string: urlString) else { return }
                    StorageManager.shared.downloadImage(from: url) { [weak self] avatarData in
                        self?.data[indexPath.row].imageData = avatarData
                        self?.viewInput?.reloadRow(indexPath)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
