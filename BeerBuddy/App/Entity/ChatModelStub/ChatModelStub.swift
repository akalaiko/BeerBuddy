//
//  ChatModelStub.swift
//  BeerBuddy
//
//  Created by Ke4a on 06.02.2023.
//

import Foundation

// FIXME: Only for tests, remove after connecting firebase.

struct ChatModelStub {
    let id: Int
    let username: String = UserModelStub.names.randomElement() ?? "Error name"
    let lastMessage: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit," +
    "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
    let date: Double
    var isPinned: Bool = false
}
