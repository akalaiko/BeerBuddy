//
//  MatchesPresenter.swift
//  BeerBuddy
//
//  Created by Ke4a on 16.01.2023.
//

import Foundation

// FIXME: Only for tests, remove after connecting firebase.

struct UserTest {
    let username: String = UserTest.names.randomElement() ?? "Error name"
    let age: Int = Int.random(in: 18...79)
    let location: String = UserTest.locations.randomElement() ?? "Error location"
    let noSmoking: Bool = Bool.random()
    let noDrinking: Bool = Bool.random()

    static var names: [String] {
        ["Valentina", "Jacques", "Guillermo",
         "Freddie", "Jaela", "Aden",
         "Viviana", "Leyla", "Priscila"]
    }

    static var locations: [String] {
        ["Moscow Red Square", "Berlin Brandenburg Gate", "Kazan Kremlin" ]
    }
}

// MARK: - Protocols

/// Controller input.
protocol MatchesViewInput: AnyObject {

}

/// Controller output.
protocol MatchesViewOutput: AnyObject {
    /// Data of users with whom there were matches.
    var data: [UserTest] { get }

    /// User preferences.
    var preferenceData: PreferenceRequest? { get }

    /// The user has selected data filtering.
    func viewRequestFiltering(_ preference: PreferenceRequest)
}

class MatchesPresenter: MatchesViewOutput {
    private(set) var preferenceData: PreferenceRequest? = .init(sex: .male, smoke: false, interest: "Obj-c") {
        willSet {
            print(newValue)
        }
    }

    func viewRequestFiltering(_ preference: PreferenceRequest) {
        preferenceData = preference
    }

    // MARK: - Public Properties
    weak var viewInput: MatchesViewInput?

    private(set) lazy var data: [UserTest] = [
        .init(), .init(), .init(), .init(),
        .init(), .init(), .init(), .init(),
        .init(), .init(), .init(), .init(),
        .init(), .init(), .init(), .init()
    ]
}
