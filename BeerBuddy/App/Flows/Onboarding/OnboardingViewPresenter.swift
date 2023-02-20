//
//  OnboardingViewPresenter.swift
//  BeerBuddy
//
//  Created by Tim on 15.02.2023.
//

import FirebaseAuth
import Foundation
import UIKit

protocol OnboardingViewInput: AnyObject {
}

protocol OnboardingViewOutput: AnyObject {
    func validateAuth()
}

final class OnboardingPresenter {
    
    // MARK: - Properties
    
    weak var viewController: (UIViewController & OnboardingViewInput)?
    
    // MARK: - Private functions

}

// MARK: - LoginViewOutput

extension OnboardingPresenter: OnboardingViewOutput {
    func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser != nil {
            let mainViewController = AppModuleBuilder.mainController()
            viewController?.navigationController?.setViewControllers([mainViewController], animated: true)
//            let navigationController = UINavigationController(rootViewController: mainViewController)
//            navigationController.modalPresentationStyle = .fullScreen
//            viewController?.present(navigationController, animated: true)
        } else {
            let loginViewController = AppModuleBuilder.loginViewController()
//            let navigationController = UINavigationController(rootViewController: loginViewController)
//            navigationController.modalPresentationStyle = .fullScreen
//            viewController?.present(navigationController, animated: true)
            viewController?.navigationController?.setViewControllers([loginViewController], animated: true)
        }
    }
}
