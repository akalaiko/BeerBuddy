//
//  NetworkMockForTests.swift
//  BeerBuddyTests
//
//  Created by Ke4a on 06.02.2023.
//
#if DEBUG
import Foundation

class NetworkMockForTests: NetworkMockProtocol {
    func fetchChats() -> [ChatModelStub] {
        let now = Date()
        return [ .init(id: 0,
                       date: now.timeIntervalSince1970),
                 .init(id: 1,
                       date: Calendar.current.date(byAdding: .second,
                                                   value: -20, to: now)!.timeIntervalSince1970),
                 .init(id: 2,
                       date: Calendar.current.date(byAdding: .minute,
                                                   value: -Int.random(in: 1...120), to: now)!.timeIntervalSince1970),
                 .init(id: 3,
                       date: Calendar.current.date(byAdding: .minute,
                                                   value: -Int.random(in: 120...360), to: now)!.timeIntervalSince1970),
                 .init(id: 4,
                       date: Calendar.current.date(byAdding: .hour,
                                                   value: -Int.random(in: 6...10), to: now)!.timeIntervalSince1970),
                 .init(id: 5,
                       date: Calendar.current.date(byAdding: .hour,
                                                   value: -Int.random(in: 10...16), to: now)!.timeIntervalSince1970),
                 .init(id: 6,
                       date: Calendar.current.date(byAdding: .hour,
                                                   value: -Int.random(in: 16...20), to: now)!.timeIntervalSince1970),
                 .init(id: 7,
                       date: Calendar.current.date(byAdding: .hour,
                                                   value: -Int.random(in: 20...24), to: now)!.timeIntervalSince1970),
                 .init(id: 8,
                       date: Calendar.current.date(byAdding: .day,
                                                   value: -Int.random(in: 2...6), to: now)!.timeIntervalSince1970),
                 .init(id: 9,
                       date: Calendar.current.date(byAdding: .day,
                                                   value: -Int.random(in: 6...12), to: now)!.timeIntervalSince1970),
                 .init(id: 10,
                       date: Calendar.current.date(byAdding: .day,
                                                   value: -Int.random(in: 12...24), to: now)!.timeIntervalSince1970)
             ]
    }

    func fetchMatches() -> [UserModelStub] {
        [
           .init(id: 0), .init(id: 1), .init(id: 2), .init(id: 3),
           .init(id: 4), .init(id: 5), .init(id: 6), .init(id: 7),
           .init(id: 8), .init(id: 9), .init(id: 10), .init(id: 11),
           .init(id: 12), .init(id: 13), .init(id: 14), .init(id: 15)
       ]
    }
}
#endif
