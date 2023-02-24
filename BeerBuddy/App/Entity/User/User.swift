//
//  User.swift
//  BeerBuddy
//
//  Created by Polina Tikhomirova on 10.01.2023.
//
// swiftlint: disable identifier_name

import UIKit

struct User {
    let name: String
    let emailAddress: String
    let sex: Sex
    let birthDate: Double
    let smoking: Smoking
    let interests: [Interests]
    let alcohols: [Alcohol]
    let matches: [String]
    let possibleMatches: [String]
    let rejectedUsers: [String]
    
    var age: Int {
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: Date(timeIntervalSince1970: birthDate), to: now)
        return ageComponents.year!
    }
    var safeEmail: String {
        var email = emailAddress.replacingOccurrences(of: ".", with: "-")
        email = email.replacingOccurrences(of: "@", with: "-")
        return email
    }
    
    var profilePictureFileName: String {
        return "\(safeEmail)_profile_picture.png"
    }
    
    var registrationComplete: Bool {
        return false
    }
    
    var noSmoking: Bool {
        return smoking == .noSmoking
    }
    var noDrinking: Bool {
        return alcohols.contains(.noDrinking)
    }
    
    init(name: String, emailAddress: String) {
        self.name = name
        self.emailAddress = emailAddress
        sex = .other
        birthDate = 0
        smoking = .ok
        interests = []
        alcohols = []
        matches = []
        possibleMatches = []
        rejectedUsers = []
    }
}

enum Smoking: String {
    case smoking
    case ok
    case noSmoking
}

enum Sex: String {
    case male
    case female
    case other
}

indirect enum Interests {
    case Sport(Sport)
    case Music(Music)
    case Movies(Movies)
}

enum Sport: String {
    case football
    case hockey
    case tennis
    case basketball
    case swimming
    case hiking
    case cycling
    case running
    case golf
}

enum Music: String {
    case rock
    case metal
    case punk
    case blues
    case country
    case electronic
    case folk
    case hipHop
    case jazz
    case soul
    case pop
}

enum Movies: String {
    case action
    case adventure
    case comedy
    case drama
    case fantasy
    case horror
    case musicals
    case mystery
    case romance
    case scienceFiction
    case sports
    case thriller
}

enum Alcohol: String {
    case beer
    case wine
    case cider
    case brandy
    case champagne
    case vodka
    case gin
    case rum
    case liqueur
    case absinthe
    case tequila
    case noDrinking
}
