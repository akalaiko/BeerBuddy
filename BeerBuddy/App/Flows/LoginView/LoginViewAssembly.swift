//
//  LoginViewAssembly.swift
//  BeerBuddy
//
//  Created by Никита Мошенцев on 14.01.2023.
//

import Foundation

final class LoginViewAssembly {
    func assemble() -> LoginViewController {
        let presenter = LoginPresenter()
        let viewController = LoginViewController(presenter: presenter)
        presenter.viewController = viewController
        
        return viewController
    }
}
