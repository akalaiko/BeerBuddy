//
//  LoginPresenter.swift
//  BeerBuddy
//
//  Created by Никита Мошенцев on 14.01.2023.
//

import Foundation
import UIKit

protocol LoginViewInput: AnyObject {
}

protocol LoginViewOutput: AnyObject {
    func tappedLoginButton(login: String, password: String)
    func tappedRegistrationButton()
}

final class LoginPresenter {
    
    // MARK: - Properties
    
    weak var viewController: (UIViewController & LoginViewInput)?
}

// MARK: - LoginViewOutput

extension LoginPresenter: LoginViewOutput {
    func tappedLoginButton(login: String, password: String) {
        if login.lowercased() == "1" && password.lowercased() == "1" {
            let mainViewController = AppModuleBuilder.mainController()
            mainViewController.modalPresentationStyle = .fullScreen
            viewController?.present(mainViewController, animated: true)
        }
    }
    
    func tappedRegistrationButton() {
        viewController?.navigationController?.pushViewController(
            AppModuleBuilder.registrationViewController(),
            animated: true)
    }
}
