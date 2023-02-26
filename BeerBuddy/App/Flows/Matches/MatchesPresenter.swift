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

    /// User preferences.
    var preferenceData: PreferenceRequest? { get }

    /// The user has selected data filtering.
    func viewRequestFiltering(_ preference: PreferenceRequest)
    
    /// Fetch information from the network.
    func viewRequestFetch()

    func viewOpenUserInfo(_ index: IndexPath)
}

class MatchesPresenter: MatchesViewOutput {
    // MARK: - Public Properties
    
    weak var viewInput: MatchesViewInput?

    private(set) lazy var data: [UserModelStub] = []
    private(set) var preferenceData: PreferenceRequest? = .init(sex: .male, smoke: false, interest: "Obj-c") {
        willSet {
            print(newValue)
        }
    }
    
    private let newtwork: NetworkMockProtocol

    init(newtwork: NetworkMockProtocol) {
        self.newtwork = newtwork
    }

    func viewRequestFiltering(_ preference: PreferenceRequest) {
        preferenceData = preference
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
