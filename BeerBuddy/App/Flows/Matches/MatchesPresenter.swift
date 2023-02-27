//
//  MatchesPresenter.swift
//  BeerBuddy
//
//  Created by Ke4a on 16.01.2023.
//

import UIKit

// MARK: - Protocols

/// Controller input.
protocol MatchesViewInput: AnyObject {
    func reloadTable()
}

/// Controller output.
protocol MatchesViewOutput: AnyObject {
    /// Data of users with whom there were matches.
    var data: [User] { get }
    var matchesCellModels: [MatchesCellModel] { get }
    /// User preferences.
    var preferenceData: PreferenceRequest? { get }
    /// The user has selected data filtering.
    func viewRequestFiltering(_ preference: PreferenceRequest)
    /// Fetch information from the network.
    func viewRequestFetch()
    func openConversation(_ index: IndexPath)
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
    weak var viewInput: (UIViewController & MatchesViewInput)?
    
    private let senderEmail = UserDefaults.standard.value(forKey: "email") as? String
    
    private(set) lazy var data: [User] = []
    private(set) lazy var matchesCellModels: [MatchesCellModel] = []

    private let network: NetworkProtocol

    init(network: NetworkProtocol) {
        self.network = network
    }

    func viewRequestFiltering(_ preference: PreferenceRequest) {
        preferenceData = preference
    }

    func viewRequestFetch() {
        data = []
        matchesCellModels = []
        let safeEmail = network.safeEmail(email: senderEmail)
        network.getAllMatches(for: safeEmail) { [weak self] result in
            switch result {
            case .success(let matches):
                matches.forEach({ match in
                    self?.network.getUser(with: match) { result in
                        switch result {
                        case .success(let user):
                            self?.data.append(user)
                            self?.configureCellModels(with: user)
                        case .failure(let error):
                            print(error)
                        }
                    }
                })
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configureCellModels(with user: User) {
        let path = network.getProfilePicturePath(email: user.safeEmail)
        StorageManager.shared.downloadURL(for: path) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let urlString):
                guard let url = URL(string: urlString) else { return }
                StorageManager.shared.downloadImage(from: url) { avatarData in
                    let model = MatchesCellModel(name: user.name,
                                                 safeEmail: user.safeEmail,
                                                 age: user.age,
                                                 noSmoking: user.noSmoking,
                                                 noDrinking: user.noDrinking,
                                                 avatarData: avatarData)
                    guard !self.matchesCellModels.contains(model) else { return }
                    self.matchesCellModels.append(model)
                    DispatchQueue.main.async {
                        self.viewInput?.reloadTable()
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func openConversation(_ indexPath: IndexPath) {
        let user = matchesCellModels[indexPath.row]
        let name = user.name
        let safeEmail = user.safeEmail
        
        network.conversationExists(with: safeEmail, completion: { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let conversationId):
                let vc = ChatViewController(with: safeEmail, id: conversationId, network: self.network)
                let nav = UINavigationController(rootViewController: vc)
                vc.isNewConversation = false
                vc.title = name
                nav.isNavigationBarHidden = false
                self.viewInput?.present(nav, animated: true)
            case .failure:
                let vc = ChatViewController(with: safeEmail, id: nil, network: self.network)
                let nav = UINavigationController(rootViewController: vc)
                vc.isNewConversation = true
                vc.title = name
                nav.isNavigationBarHidden = false
                self.viewInput?.present(nav, animated: true)
            }
        })
    }
}
