//
//  MatchesView.swift
//  BeerBuddy
//
//  Created by Ke4a on 16.01.2023.
//

import UIKit

class MatchesView: UIView {
    // MARK: - Visual Components

    private lazy var headerView: HeaderView = {
        let view = HeaderView(title: "MATCHES")
        view.font = AppStyles.font.big
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var controller: FilterViewDelegate?

    // MARK: - Initialization

    /// /// Creates  matches list.
    /// - Parameter controller: The controller that manages the table.
    init(controller: UITableViewDataSource & UITableViewDelegate & FilterViewDelegate) {
        super.init(frame: .zero)
        self.controller = controller
        registrationTableView(controller)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setting UI Methods

    /// Settings visual components.
    func setupUI() {
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
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor,
                                           constant: 1),
            tableView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])

        headerView.setRightButton(
            imageName: AppData.imageName.slider,
            target: self,
            action: #selector(filterAction))

        setUITests()
    }

    func addFilterView() {
        let view = FilterView(delegate: controller)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        guard let buttonFrame = self.headerView.buttonFrame else { return }
        view.appearanceAnimation(self.headerView.convert( buttonFrame, to: self))
    }

    // MARK: - Public Methods

    /// Register a table and connect a delegation.
    /// - Parameter controller: Delegate table.
    func registrationTableView(_ controller: UITableViewDataSource & UITableViewDelegate) {
        tableView.register(MatchesTableViewCell.self,
                           forCellReuseIdentifier: MatchesTableViewCell.identifier)
        tableView.dataSource = controller
        tableView.delegate = controller
    }

    // MARK: - Private Methods

    /// Setting ui test Identifiers.
    private func setUITests() {
        self.accessibilityIdentifier = "matchesView"
        headerView.accessibilityIdentifier = "headerView"
        tableView.accessibilityIdentifier = "tableView"
    }

    // MARK: - Actions

    /// The action of the header button.
    @objc private func filterAction() {
        headerView.rightButtonClickAnimation()
        addFilterView()
    }
}
