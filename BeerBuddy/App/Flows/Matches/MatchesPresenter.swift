//
//  MatchesPresenter.swift
//  BeerBuddy
//
//  Created by Ke4a on 16.01.2023.
//

import Foundation

// MARK: - Protocols

/// Controller input.
protocol MatchesViewInput: AnyObject {
    func reloadTable()
}

/// Controller output.
protocol MatchesViewOutput: AnyObject {
    /// Data of users with whom there were matches.
    var data: [UserModelStub] { get }
    /// Fetch information from the network.
    func viewRequestFetch()

    func viewOpenUserInfo(_ index: IndexPath)
}

class MatchesPresenter: MatchesViewOutput {
    // MARK: - Public Properties
    weak var viewInput: MatchesViewInput?

    private(set) lazy var data: [UserModelStub] = []

    private let newtwork: NetworkMockProtocol

    init(newtwork: NetworkMockProtocol) {
        self.newtwork = newtwork
    }

    func viewRequestFetch() {
        self.data = newtwork.fetchMatches()
        viewInput?.reloadTable()
    }

    func viewOpenUserInfo(_ index: IndexPath) {
        let user = data[index.row]
        print(user.id)
    }
}
