//
//  LoginPresenter.swift
//  BeerBuddy
//
//  Created by Никита Мошенцев on 14.01.2023.
//

import FirebaseAuth
import Foundation
import UIKit

protocol LoginViewInput: AnyObject {
    func alertLoginError(message: String)
}

protocol LoginViewOutput: AnyObject {
    func tappedLoginButton(login: String, password: String)
    func tappedRegistrationButton()
}

final class LoginPresenter {
    
    // MARK: - Properties
    
    weak var viewController: (UIViewController & LoginViewInput)?
    
    // MARK: - Private functions
    
}

// MARK: - LoginViewOutput

extension LoginPresenter: LoginViewOutput {
    
    func tappedLoginButton(login: String, password: String) {
        
        guard !login.isEmpty, !password.isEmpty else {
            viewController?.alertLoginError(message: "Please enter all info to log in.")
            return
        }
        
        // firebase login
        FirebaseAuth.Auth.auth().signIn(withEmail: login, password: password) { [weak self] _, error in
            guard let self else { return }
            guard error == nil else {
                self.viewController?.alertLoginError(message: "Failed to log in user with login: \(login)")
                return
            }
            // here we should get data for user from database
            let safeEmail = DatabaseManager.safeEmail(email: login)
            
            DatabaseManager.shared.getDataFor(path: safeEmail, completion: { result in
                switch result {
                case .success(let data):
                    guard let userData = data as? [String: Any],
                          let name = userData["name"] as? String
                    else {
                        return
                    }
                    UserDefaults.standard.set(login, forKey: "email")
                    UserDefaults.standard.set(name, forKey: "name")
                    
                case .failure(let error):
                    print("failed to read data with error:", error)
                }
            })
            
            let mainViewController = AppModuleBuilder.mainController()
            self.viewController?.present(mainViewController, animated: true)
        }
    }
    
    func tappedRegistrationButton() {
        viewController?.navigationController?.pushViewController(
            AppModuleBuilder.registrationViewController(),
            animated: true)
    }
}
