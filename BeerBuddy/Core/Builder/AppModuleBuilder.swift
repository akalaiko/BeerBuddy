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
        let network = FirebaseNetwork()
        let presenter = LoginPresenter(network: network)
        let viewController = LoginViewController(presenter: presenter)
        presenter.viewController = viewController
        viewController.modalPresentationStyle = .fullScreen
        
        return viewController
    }
    
    static func registrationViewController() -> UIViewController & RegistrationViewInput {
        let network = FirebaseNetwork()
        let presenter = RegistrationPresenter(network: network)
        let viewController = RegistrationViewController(presenter: presenter)
        presenter.viewController = viewController
        
        return viewController
    }

    static func matchesController() -> UIViewController & MatchesViewInput {
        let network = FirebaseNetwork()
        let presenter = MatchesPresenter(network: network)
        let viewController = MatchesViewController(presenter: presenter)
        presenter.viewInput = viewController

        return viewController
    }
    
    static func profilePropertiesViewController() -> UIViewController & ProfilePropertiesViewInput {
        let locationManager = LocationManager()
        let presenter = ProfilePropertiesPresenter(locationManager: locationManager)
        let viewController = ProfilePropertiesViewController(presenter: presenter)
        presenter.viewController = viewController
        return viewController
    }

    static func chatsController() -> UIViewController & ChatsViewInput {
//        let dateFormatter = DateFormatterHelper()
        let network = FirebaseNetwork()
        let presenter = ChatsPresenter(network: network)
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
        let mainViewController = MainViewController()
        mainViewController.modalPresentationStyle = .fullScreen
        return mainViewController
    }

    static func testController() -> UIViewController {
           return ViewController()
    }
}
