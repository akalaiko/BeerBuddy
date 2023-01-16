//
//  LoginPresenter.swift
//  BeerBuddy
//
//  Created by Никита Мошенцев on 14.01.2023.
//

import Foundation

protocol LoginViewInput: AnyObject {
    
}

protocol LoginViewOutput: AnyObject {
    func tappedLoginButton()
    func tappedRegistrationButton()
}

final class LoginPresenter {
    // MARK: - Properties
    weak var viewController: LoginViewInput?
}

// MARK: - LoginViewOutput
extension LoginPresenter: LoginViewOutput {
    func tappedLoginButton() {
        print("Login")
    }
    
    func tappedRegistrationButton() {
        print("Registration")
    }
}
