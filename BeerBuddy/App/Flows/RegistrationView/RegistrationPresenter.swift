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
    func didTapRegistrationButton(name: String, login: String, password: String, repeatPassword: String)
}

final class RegistrationPresenter {
    weak var viewController: (UIViewController & RegistrationViewInput)?
    
    // MARK: - Private methods
}

// MARK: - Extensions

extension RegistrationPresenter: RegistrationViewOutput {
    
    func didTapRegistrationButton(name: String, login: String, password: String, repeatPassword: String) {
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
            
            FirebaseAuth.Auth.auth().createUser(withEmail: login, password: password) { authResult, error in
                guard authResult != nil, error == nil else {
                    self.viewController?.alertLoginError(message: "Error while creating new user.")
                    return
                }
                let chatUser = ChatAppUser(name: name, emailAddress: login)
                DatabaseManager.shared.insertUser(with: chatUser, completion: { success in
                    if success {
                        // StorageManager should upload the profile picture to database here
                        let mainViewController = AppModuleBuilder.mainController()
                        self.viewController?.present(mainViewController, animated: true)
                    }
                })
            }
        })
    }
}
