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
            viewController?.present(mainViewController, animated: true)
        } else {
            let mainViewController = AppModuleBuilder.loginViewController()
            viewController?.present(mainViewController, animated: true)
        }
    }
}
