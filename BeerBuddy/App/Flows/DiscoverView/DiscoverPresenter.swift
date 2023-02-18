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
    func didTapLeftButton()
    func didTapRightButton()
}

final class DiscoverPresenter {
    weak var viewController: DiscoverViewInput?
}

// MARK: - Extensions

extension DiscoverPresenter: DiscoverViewOutput {
    func didTapLeftButton() {
        print(#function)
    }
    
    func didTapRightButton() {
        print(#function)
    }
}
