//
//  DiscoverPresenter.swift
//  BeerBuddy
//
//  Created by Polina Tikhomirova on 18.02.2023.
//

import Foundation

// MARK: - Protocols

/// Controller input.
protocol DiscoverViewInput: AnyObject { }

/// Controller output.
protocol DiscoverViewOutput: AnyObject {
    func didTapSorryButton()
    func didTapCheersButton()
}

final class DiscoverPresenter {
    weak var viewController: DiscoverViewInput?
}

// MARK: - Extensions

extension DiscoverPresenter: DiscoverViewOutput {
    func didTapSorryButton() {
        print(#function)
    }
    
    func didTapCheersButton() {
        print(#function)
    }
}

