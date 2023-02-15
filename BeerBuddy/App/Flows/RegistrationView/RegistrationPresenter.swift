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
protocol RegistrationViewInput: AnyObject {}

/// Controller output.
protocol RegistrationViewOutput: AnyObject {
    func didTapRegistrationButton(name: String, login: String, password: String, repeatPassword: String)
}

final class RegistrationPresenter {
    weak var viewController: (UIViewController & RegistrationViewInput)?
}

// MARK: - Extensions

extension RegistrationPresenter: RegistrationViewOutput {
    
    func didTapRegistrationButton(name: String, login: String, password: String, repeatPassword: String) {
        guard !name.isEmpty, !login.isEmpty, !password.isEmpty, !repeatPassword.isEmpty else {
            alertLoginError(with: "Please enter all info to create a new account.")
            return
        }
        print("passed first guard, let's compare passwords: ", password, repeatPassword)
        guard password == repeatPassword else {
            alertLoginError(with: "Please enter the same password in both fields")
            return
        }
        
        // firebase register
        
        DatabaseManager.shared.userExists(with: login, completion: { [weak self] exists in
            guard let self else { return }
            guard !exists else {
                self.alertLoginError(with: "User already exists!")
                return
            }
            
            FirebaseAuth.Auth.auth().createUser(withEmail: login, password: password) { authResult, error in
                guard authResult != nil, error == nil else {
                    print("error creating new user")
                    return
                }
                let chatUser = ChatAppUser(name: name, emailAddress: login)
                DatabaseManager.shared.insertUser(with: chatUser, completion: { success in
                    if success {
                        // StorageManager should upload th profile picture to database here
                        let mainViewController = AppModuleBuilder.mainController()
                        mainViewController.modalPresentationStyle = .fullScreen
                        self.viewController?.present(mainViewController, animated: true)
                    }
                })
            }
        })
    }
    
    func alertLoginError(with message: String = "Please enter all info to create a new account.") {
        let alert = UIAlertController(title: "Ooops!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        viewController?.present(alert, animated: true)
    }
}
