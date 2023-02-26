//
//  Sender.swift
//  BeerBuddy
//
//  Created by Tim on 22.02.2023.
//

import Foundation
import MessageKit

struct Sender: SenderType {
    var senderId: String
    var displayName: String
    var photoURL: String
}
