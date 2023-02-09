//
//  AppUITestBuilder.swift
//  BeerBuddy
//
//  Created by Ke4a on 09.02.2023.
//

#if DEBUG
import Foundation
import UIKit

enum AppUITestBuilder {
    static func matchesController() -> UIViewController & MatchesViewInput {
        let network = NetworkMockForTests()
        let presenter = MatchesPresenter(newtwork: network)
        let viewController = MatchesViewController(presenter: presenter)
        presenter.viewInput = viewController

        return viewController
    }
}
#endif
