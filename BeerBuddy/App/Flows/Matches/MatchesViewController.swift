//
//  MatchesViewController.swift
//  BeerBuddy
//
//  Created by Ke4a on 16.01.2023.
//

import UIKit

class MatchesViewController: UIViewController {
    // MARK: - Private Properties

    private var matchesView: MatchesView {
        guard let view = self.view as? MatchesView else {
            let correctView = MatchesView(controller: self)
            return correctView
        }

        return view
    }

    /// Controller presenter.
    private var presenter: MatchesViewOutput?

    // MARK: - Initialization

    /// Create controller screen "Matches"
    /// - Parameter presenter: Controller presenter.
    required init(presenter: MatchesViewOutput) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()
        self.view = matchesView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        matchesView.setupUI()
        presenter?.viewRequestFetch()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    // MARK: - Actions

}

// MARK: - MatchesViewInput

extension MatchesViewController: MatchesViewInput {

}

// MARK: - FilterViewDelegate

extension MatchesViewController: FilterViewDelegate {
    var userPreference: PreferenceRequest? {
        presenter?.preferenceData
    }

    func sendFiltrationData(_ data: PreferenceRequest) {
        presenter?.viewRequestFiltering(data)
    }
    func reloadTable() {
        matchesView.reloadTable()
    }
}

// MARK: - UITableViewDataSource

extension MatchesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.matchesCellModels.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MatchesTableViewCell.identifier)
                as? MatchesTableViewCell else { preconditionFailure("MatchesTableViewCell error") }
        let user = presenter?.matchesCellModels[indexPath.row]
        cell.configure(user)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MatchesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        AppStyles.size.height.tableCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.openConversation(indexPath)
    }
}
