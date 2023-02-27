//
//  DiscoverPresenter.swift
//  BeerBuddy
//
//  Created by Polina Tikhomirova on 18.02.2023.
//

import FirebaseAuth
import UIKit

// MARK: - Protocols

protocol UserProfileViewInput: AnyObject {
    func updateViewWithUserData(model: UserCardViewModel)
}

protocol UserProfileViewOutput: AnyObject {
    func didTapLogOut()
    func didTapEditButton()
    func getUserData()
}

final class UserProfilePresenter {
    weak var viewController: (UIViewController & UserProfileViewInput)?
    let email = UserDefaults.standard.value(forKey: "email") as? String

    let network: NetworkProtocol

    init(network: NetworkProtocol) {
        self.network = network
    }
}

// MARK: - Extensions

extension UserProfilePresenter: UserProfileViewOutput {
    func didTapLogOut() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Log out", style: .destructive) { [weak self] _ in
            UserDefaults.standard.set(nil, forKey: "email")
            UserDefaults.standard.set(nil, forKey: "name")
            UserDefaults.standard.set(nil, forKey: "profile_picture_url")
            UserDefaults.standard.set(nil, forKey: "pinnedChats")
            
            do {
                try FirebaseAuth.Auth.auth().signOut()
                let loginViewController = AppModuleBuilder.loginViewController()
                self?.viewController?.navigationController?.setViewControllers([loginViewController], animated: true)
            } catch {
                print("failed")
            }
        })
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        viewController?.present(actionSheet, animated: true)
    }
    
    func getUserData() {
        let safeEmail = network.safeEmail(email: email)
        network.getUser(with: safeEmail, completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user):
                let path = self.network.getProfilePicturePath(email: safeEmail)
                StorageManager.shared.downloadURL(for: path) { [weak self] result in
                    switch result {
                    case .success(let urlString):
                        guard let url = URL(string: urlString) else { return }
                        StorageManager.shared.downloadImage(from: url) { avatarData in
                            guard let avatar = UIImage(data: avatarData) else { return }
                            DispatchQueue.main.async {
                                let model = UserCardViewModel(userAvatar: avatar,
                                                              interestsList: user.interestsStrings
                                                                                            .joined(separator: ", "),
                                                              userBio: "",
                                                              rejectButtonTitle: "",
                                                              acceptButtonTitle: "",
                                                              name: user.name,
                                                              age: user.age)
                                print(model)
                                self?.viewController?.updateViewWithUserData(model: model)
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func didTapEditButton() {
        print(#function)
    }
}
