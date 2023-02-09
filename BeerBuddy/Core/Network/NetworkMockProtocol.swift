//
//  NetworkMockProtocol.swift
//  BeerBuddy
//
//  Created by Ke4a on 09.02.2023.
//

import Foundation

protocol NetworkMockProtocol {
    func fetchChats() -> [ChatModelStub]
    func fetchMatches() -> [UserModelStub]
}
