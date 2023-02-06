//
//  RegistrationPresenter.swift
//  BeerBuddy
//
//  Created by Polina Tikhomirova on 17.01.2023.
//

import Foundation

// MARK: - Protocols 

/// Controller input.
protocol RegistrationViewInput: AnyObject { }

/// Controller output.
protocol RegistrationViewOutput: AnyObject {
    func didTapRegistrationButton()
}

final class RegistrationPresenter {
    weak var viewController: RegistrationViewInput?
}

// MARK: - Extensions

extension RegistrationPresenter: RegistrationViewOutput {
    func didTapRegistrationButton() {
        print(#function)
    }
}
