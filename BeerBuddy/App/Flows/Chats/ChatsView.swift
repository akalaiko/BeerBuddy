//
//  ChatsView.swift
//  BeerBuddy
//
//  Created by Ke4a on 04.02.2023.
//

import UIKit

class ChatsView: UIView {
    typealias Controller = (UITableViewDelegate & UITableViewDataSource)

    // MARK: - Visual Components

    private lazy var headerView: HeaderView = {
        let header = HeaderView(title: "CHATS")
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    // MARK: - Private Properties

    private weak var controller: Controller?

    // MARK: - Initialization

    init(controller: Controller) {
        super.init(frame: .zero)
        self.controller = controller
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setting UI Methods

    /// Settings of visual components.
    func setupUI() {
        backgroundColor = AppStyles.color.background.main
        tableView.backgroundColor = AppStyles.color.background.main
        tableView.separatorStyle = .none

        addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: AppStyles.size.height.header)
        ])

        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])

        guard let controller = controller else { preconditionFailure("No controller") }

        settingsTable(controller)

        #if DEBUG
        setUITests()
        #endif
    }
    
    override func reloadInputViews() {
        tableView.reloadData()
    }

    func reloadRow(_ index: IndexPath) {
        tableView.reloadRows(at: [index], with: .automatic)
    }

    // MARK: - Private Methods

    /// Settings the table.
    /// - Parameter controller: The controller in which controls the table.
    private func settingsTable(_ controller: Controller) {
        tableView.delegate = controller
        tableView.dataSource = controller
        tableView.register(ChatsTableViewCell.self, forCellReuseIdentifier: ChatsTableViewCell.identifier)
    }

}

// MARK: - UI Testing

#if DEBUG
extension ChatsView {
    /// Setting ui test Identifiers.
    private func setUITests() {
        self.accessibilityIdentifier = "chats"
        headerView.accessibilityIdentifier = "chatsHeader"
        tableView.accessibilityIdentifier = "chatsTable"
    }
}
#endif
