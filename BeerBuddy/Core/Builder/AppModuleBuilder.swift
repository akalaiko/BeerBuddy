//
//  AppModuleBuilder.swift
//  BeerBuddy
//
//  Created by Никита Мошенцев on 15.01.2023.
//

import Foundation
import UIKit

enum AppModuleBuilder {
    static func loginViewController() -> UIViewController & LoginViewInput {
        let presenter = LoginPresenter()
        let viewController = LoginViewController(presenter: presenter)
        presenter.viewController = viewController
        
        return viewController
    }

    static func matchesController() -> UIViewController & MatchesViewInput {
        let presenter = MatchesPresenter()
        let viewController = MatchesViewController(presenter: presenter)
        presenter.viewInput = viewController

        return viewController
    }
}
