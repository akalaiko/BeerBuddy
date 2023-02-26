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
    /// Fetch information from the network.
    func viewRequestFetch()
    func openConversation(_ index: IndexPath)
}

class MatchesPresenter: MatchesViewOutput {
    
    // MARK: - Public Properties
    weak var viewInput: (UIViewController & MatchesViewInput)?
    
    private let senderEmail = UserDefaults.standard.value(forKey: "email") as? String
    
    private(set) lazy var data: [User] = []
    private(set) lazy var matchesCellModels: [MatchesCellModel] = []
    
    func viewRequestFetch() {
        data = []
        matchesCellModels = []
        let safeEmail = DatabaseManager.safeEmail(email: senderEmail)
        DatabaseManager.shared.getAllMatches(for: safeEmail) { [weak self] result in
            switch result {
            case .success(let matches):
                matches.forEach({ match in
                    DatabaseManager.shared.getUser(with: match) { result in
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
        let path = DatabaseManager.getProfilePicturePath(email: user.safeEmail)
        print(path)
        StorageManager.shared.downloadURL(for: path) { [weak self] result in
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
                    self?.matchesCellModels.append(model)
                    DispatchQueue.main.async {
                        self?.viewInput?.reloadTable()
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
        
        DatabaseManager.shared.conversationExists(with: safeEmail, completion: { [weak self] result in
            switch result {
            case .success(let conversationId):
                let vc = ChatViewController(with: safeEmail, id: conversationId)
                let nav = UINavigationController(rootViewController: vc)
                vc.isNewConversation = false
                vc.title = name
                nav.isNavigationBarHidden = false
                self?.viewInput?.present(nav, animated: true)
            case .failure:
                let vc = ChatViewController(with: safeEmail, id: nil)
                let nav = UINavigationController(rootViewController: vc)
                vc.isNewConversation = true
                vc.title = name
                nav.isNavigationBarHidden = false
                self?.viewInput?.present(nav, animated: true)
            }
        })
    }
}
