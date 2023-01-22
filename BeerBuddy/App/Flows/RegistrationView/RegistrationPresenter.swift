//
//  RegistrationPresenter.swift
//  BeerBuddy
//
//  Created by Polina Tikhomirova on 17.01.2023.
//

import Foundation

protocol RegistrationViewInput: AnyObject { }

protocol RegistrationViewOutput: AnyObject {
    func didTapRegistrationButton()
}

final class RegistrationPresenter {
    weak var viewController: RegistrationViewController?
}

// MARK: - Extension
extension RegistrationPresenter: RegistrationViewOutput {
    func didTapRegistrationButton() {
        print(#function)
    }
}
