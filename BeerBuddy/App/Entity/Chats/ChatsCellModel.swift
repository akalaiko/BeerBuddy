//
//  ChatsCellModel.swift
//  BeerBuddy
//
//  Created by Ke4a on 27.02.2023.
//

import Foundation

struct ChatsCellModel {
    let id: String
    let email: String
    let username: String
    let lastMessage: String
    let date: String
    var isPinned: Bool
    var imageData: Data?
}
