//
//  RegistrationPresenter.swift
//  BeerBuddy
//
//  Created by Polina Tikhomirova on 17.01.2023.
//

import FirebaseAuth
import Foundation
import UIKit

// MARK: - Protocols 

/// Controller input.
protocol RegistrationViewInput: AnyObject {
    func alertLoginError(message: String)
}

/// Controller output.
protocol RegistrationViewOutput: AnyObject {
    func didTapRegistrationButton(name: String,
                                  login: String,
                                  password: String,
                                  repeatPassword: String,
                                  avatar: UIImage)
}

final class RegistrationPresenter {
    weak var viewController: (UIViewController & RegistrationViewInput)?
    
    // MARK: - Private methods
}

// MARK: - Extensions

extension RegistrationPresenter: RegistrationViewOutput {
    
    func didTapRegistrationButton(name: String,
                                  login: String,
                                  password: String,
                                  repeatPassword: String,
                                  avatar: UIImage) {
        guard !name.isEmpty, !login.isEmpty, !password.isEmpty, !repeatPassword.isEmpty else {
            viewController?.alertLoginError(message: "Please enter all info to create a new account.")
            return
        }
        guard password == repeatPassword else {
            viewController?.alertLoginError(message: "Please enter the same password in both fields")
            return
        }
        
        // firebase register
        DatabaseManager.shared.userExists(with: login, completion: { [weak self] exists in
            guard let self else { return }
            guard !exists else {
                self.viewController?.alertLoginError(message: "User already exists!")
                return
            }
            
            FirebaseAuth.Auth.auth().createUser(withEmail: login, password: password) { [weak self] authResult, error in
                guard authResult != nil, error == nil else {
                    self?.viewController?.alertLoginError(message: "Error while creating new user.")
                    return
                }
//                let chatUser = User(name: name, emailAddress: login)
                let mockChatUser = User(mockName: name, emailAddress: login)
                DatabaseManager.shared.insertUser(with: mockChatUser, completion: { success in
                    if success {
                        guard let data = avatar.pngData() else { return }
                        let fileName = mockChatUser.profilePictureFileName
                        StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName) { result in
                            switch result {
                            case .success(let downloadURL):
                                UserDefaults.standard.set(downloadURL, forKey: "profile_picture_url")
                                print(downloadURL)
                            case .failure(let error):
                                print(error)
                            }
                        }
                        UserDefaults.standard.set(login, forKey: "email")
                        UserDefaults.standard.set(name, forKey: "name")
                        let mainViewController = AppModuleBuilder.mainController()
                        self?.viewController?.navigationController?.setViewControllers([mainViewController],
                                                                                       animated: true)
                    }
                })
            }
        })
    }
}
