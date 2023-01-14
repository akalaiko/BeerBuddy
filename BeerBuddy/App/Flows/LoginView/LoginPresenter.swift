//
//  LoginPresenter.swift
//  BeerBuddy
//
//  Created by Никита Мошенцев on 14.01.2023.
//

import Foundation

protocol LoginViewOutput: AnyObject {
    func tappedLoginButton()
    func tappedRegistrationButton()
}

final class LoginPresenter {
    // MARK: - Properties
    weak var viewController: LoginViewInput?
}

// MARK: - Release LoginViewOutput
extension LoginPresenter: LoginViewOutput {
    func tappedLoginButton() {
        print("Login")
    }
    
    func tappedRegistrationButton() {
        print("Registration")
    }
}
