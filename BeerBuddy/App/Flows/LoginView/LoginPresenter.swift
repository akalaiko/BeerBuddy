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
    
    private func alertLoginError(message: String = "Please enter all info to log in.") {
        viewController?.alertLoginError(message: message)
    }
    
}

// MARK: - LoginViewOutput

extension LoginPresenter: LoginViewOutput {
    
    func tappedLoginButton(login: String, password: String) {
        
        guard !login.isEmpty, !password.isEmpty else {
            alertLoginError()
            return
        }
        
        // firebase login
        FirebaseAuth.Auth.auth().signIn(withEmail: login, password: password) { [weak self] authResult, error in
            guard let self else { return }
            guard let result = authResult, error == nil else {
                self.alertLoginError(message: "Failed to log in user with login: \(login)")
                return
            }

            // here we should get data for user from database
            print("great success", result.user)
            
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
