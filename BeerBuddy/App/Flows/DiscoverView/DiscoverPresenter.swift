//
//  DiscoverPresenter.swift
//  BeerBuddy
//
//  Created by Polina Tikhomirova on 18.02.2023.
//

import Foundation

// MARK: - Protocols

protocol DiscoverViewInput: AnyObject { }

protocol DiscoverViewOutput: AnyObject {
    func didTapRejectButton()
    func didTapAcceptButton()
}

final class DiscoverPresenter {
    weak var viewController: DiscoverViewInput?
}

// MARK: - Extensions

extension DiscoverPresenter: DiscoverViewOutput {
    func didTapRejectButton() {
        print(#function)
    }
    
    func didTapAcceptButton() {
        print(#function)
    }
}
