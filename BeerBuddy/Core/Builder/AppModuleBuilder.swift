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
    
    static func registrationViewController() -> UIViewController & RegistrationViewInput {
        let presenter = RegistrationPresenter()
        let viewController = RegistrationViewController(presenter: presenter)
        presenter.viewController = viewController
        
        return viewController
    }

    static func matchesController() -> UIViewController & MatchesViewInput {
        let network = NetworkMockForTests()
        let presenter = MatchesPresenter(newtwork: network)
        let viewController = MatchesViewController(presenter: presenter)
        presenter.viewInput = viewController

        return viewController
    }

    static func chatsController() -> UIViewController & ChatsViewInput {
        let dateFormatter = DateFormatterHelper()
        let network = NetworkMockForTests()
        let presenter = ChatsPresenter(dateFormatter: dateFormatter, network: network)
        let viewController = ChatsViewController(presenter: presenter)
        presenter.viewInput = viewController
        return viewController
    }
    
    static func discoverViewController() -> UIViewController & DiscoverViewInput {
        let presenter = DiscoverPresenter()
        let viewController = DiscoverViewController(presenter: presenter)
        presenter.viewController = viewController
        
        return viewController
    }

    static func mainController() -> UIViewController {
        return MainViewController()
    }

    static func testController() -> UIViewController {
           return ViewController()
    }
}
