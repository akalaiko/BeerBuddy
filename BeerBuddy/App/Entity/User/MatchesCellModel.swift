//
//  MatchesCellModel.swift
//  BeerBuddy
//
//  Created by Tim on 25.02.2023.
//

import UIKit

struct MatchesCellModel {
    let name: String
    let safeEmail: String
    let age: Int
    let location: String = "Kyiv"
    var avatarData: Data
    var noSmoking: Bool
    var noDrinking: Bool
    
    init(name: String,
         safeEmail: String,
         age: Int,
         noSmoking: Bool,
         noDrinking: Bool,
         avatarData: Data) {
        self.name = name
        self.safeEmail = safeEmail
        self.age = age
        self.noSmoking = noSmoking
        self.noDrinking = noDrinking
        self.avatarData = avatarData
    }
}
