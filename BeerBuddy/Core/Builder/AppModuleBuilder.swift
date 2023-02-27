//
//  AppModuleBuilder.swift
//  BeerBuddy
//
//  Created by Никита Мошенцев on 15.01.2023.
//

import Foundation
import UIKit

enum AppModuleBuilder {
    
    static func onboardingViewController() -> UIViewController & OnboardingViewInput {
        let presenter = OnboardingPresenter()
        let viewController = OnboardingViewController(presenter: presenter)
        presenter.viewController = viewController
        
        return viewController
    }
    
    static func loginViewController() -> UIViewController & LoginViewInput {
        let presenter = LoginPresenter()
        let viewController = LoginViewController(presenter: presenter)
        presenter.viewController = viewController
        viewController.modalPresentationStyle = .fullScreen
        
        return viewController
    }
    
    static func registrationViewController() -> UIViewController & RegistrationViewInput {
        let presenter = RegistrationPresenter()
        let viewController = RegistrationViewController(presenter: presenter)
        presenter.viewController = viewController
        
        return viewController
    }

    static func matchesController() -> UIViewController & MatchesViewInput {
        let presenter = MatchesPresenter()
        let viewController = MatchesViewController(presenter: presenter)
        presenter.viewInput = viewController

        return viewController
    }

    static func chatsController() -> UIViewController & ChatsViewInput {
//        let dateFormatter = DateFormatterHelper()
//        let network = NetworkMockForTests()
        let presenter = ChatsPresenter()
        let viewController = ChatsViewController(presenter: presenter)
        presenter.viewInput = viewController
        return viewController
    }

    static func mainController() -> UIViewController {
        let mainViewController = MainViewController()
        mainViewController.modalPresentationStyle = .fullScreen
        return MainViewController()
    }

    static func testController() -> UIViewController {
           return ViewController()
    }
}
