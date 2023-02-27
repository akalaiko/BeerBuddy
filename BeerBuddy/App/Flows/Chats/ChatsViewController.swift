//
//  ChatsViewController.swift
//  BeerBuddy
//
//  Created by Ke4a on 04.02.2023.
//

import UIKit

class ChatsViewController: UIViewController {
    // MARK: - Private Properties

    private var chatsView: ChatsView {
        return self.view as? ChatsView ?? ChatsView(controller: self)
    }

    private var presenter: ChatsViewOutput?
    
    var loginObserver: NSObjectProtocol?

    // MARK: - Initialization

    init(presenter: ChatsViewOutput) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()
        self.view = chatsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        chatsView.setupUI()
        presenter?.startListeningForConversations()
        
        loginObserver = NotificationCenter.default.addObserver(forName: Notification.Name("didLogInNotification"),
                                                               object: nil,
                                                               queue: .main,
                                                               using: { [weak self] _ in
            self?.presenter?.startListeningForConversations()
        })
    }

    // MARK: - Private Methods

    /// Cell delete action.
    /// - Parameters:
    ///   - tableView: Table.
    ///   - indexPath: Index path cell.
    /// - Returns: Сell delete action.
    private func deleteCellAction(tableView: UITableView, indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, complete in
            self?.presenter?.viewDeleteCell(indexPath)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            complete(true)
        }
        return action
    }

    /// Action pin/unpin cell.
    /// - Parameters:
    ///   - pinned: Pin/Unpin.
    ///   - tableView: Table.
    ///   - indexPath:
    /// - Returns: Action based on whether you need to pin or unpin the cell.
    private func toggleСellFixationAction(_ pinned: Bool, tableView: UITableView, indexPath: IndexPath
    ) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, complete in
            guard let presenter = self?.presenter else {
                complete(false)
                return
            }

            let newIndex = presenter.viewToggleCellPin(indexPath)
            tableView.moveRow(at: indexPath, to: newIndex)
            tableView.reloadRows(at: [newIndex], with: .automatic)
            complete(true)
        }
        action.image = UIImage(named: pinned ? AppData.imageName.unpin : AppData.imageName.pin)
        action.backgroundColor = pinned ? .systemGray : .systemGreen

        return action
    }
}

// MARK: - ChatsViewInput

extension ChatsViewController: ChatsViewInput {

}

// MARK: - UITableViewDataSource

extension ChatsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.dataCount ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatsTableViewCell.identifier,
                                                       for: indexPath)  as? ChatsTableViewCell
        else { preconditionFailure("No cell") }
        guard let presenter = presenter else { preconditionFailure("No presenter") }

        let data = presenter.viewRequestCellData(indexPath)
        
        cell.configure(email: data.email, userName: data.username, lastMessage: data.lastMessage,
                       date: data.date, pinned: data.isPinned)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ChatsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        AppStyles.size.height.tableCell
    }

    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = deleteCellAction(tableView: tableView, indexPath: indexPath)
        return UISwipeActionsConfiguration(actions: [action])
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let cellIsPinned = presenter?.viewCheckCellIsPinned(indexPath) else { return nil }
        
        let action = toggleСellFixationAction(cellIsPinned, tableView: tableView, indexPath: indexPath)
        return UISwipeActionsConfiguration(actions: [action])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.viewOpenScreenChat(indexPath)
    }
}
