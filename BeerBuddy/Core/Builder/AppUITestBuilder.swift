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
        let presenter = MatchesPresenter()
        let viewController = MatchesViewController(presenter: presenter)
        presenter.viewInput = viewController

        return viewController
    }

    static func chatsController() -> UIViewController & ChatsViewInput {
        let dateFormatter = DateFormatterHelper()
        let network = NetworkMockForTests()
        let presenter = ChatsPresenter(dateFormatter: dateFormatter, network: network)
        let viewcController = ChatsViewController(presenter: presenter)
        presenter.viewInput = viewcController
        return viewcController
    }
}
#endif
