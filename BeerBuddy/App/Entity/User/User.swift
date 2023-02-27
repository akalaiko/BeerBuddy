//
//  User.swift
//  BeerBuddy
//
//  Created by Polina Tikhomirova on 10.01.2023.
//

import UIKit

struct User {
    let name: String
    let emailAddress: String
    let sex: Sex
    let birthDate: Double
    let location: String
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
    
    var interestsStrings: [String] {
        interests.compactMap({ $0.rawValue })
    }
    
    var alcoholStrings: [String] {
        alcohols.compactMap({ $0.rawValue })
    }
    
    var profilePictureFileName: String {
        return "\(safeEmail)_profile_picture.png"
    }
    
    var registrationComplete: Bool {
        return !interests.isEmpty && !alcohols.isEmpty
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
        location = ""
        interests = []
        alcohols = []
        matches = []
        possibleMatches = []
        rejectedUsers = []
    }
    
    init(mockName: String, emailAddress: String) {
        self.name = mockName
        self.emailAddress = emailAddress
        sex = .female
        birthDate = 716947200
        smoking = .noSmoking
        location = "Kyiv"
        interests = [.football, .fantasy, .adventure]
        alcohols = [.beer, .tequila, .gin]
        matches = ["some first match", "some second match", "some third match"]
        possibleMatches = ["some possible first match", "some possiblesecond match"]
        rejectedUsers = ["some first rejected", "some second rejected"]
    }
    
    init(name: String,
         emailAddress: String,
         sex: String,
         birthDate: Double,
         smoking: String,
         location: String,
         interestsStrings: [String],
         matches: [String],
         alcoholStrings: [String],
         possibleMatches: [String],
         rejectedUsers: [String]) {
        
        self.name = name
        self.emailAddress = emailAddress
        self.sex = Sex(rawValue: sex) ?? .other
        self.birthDate = birthDate
        self.smoking = Smoking(rawValue: smoking) ?? .noSmoking
        self.location = location
        self.interests = interestsStrings.compactMap({ Interests(rawValue: $0) })
        self.alcohols = alcoholStrings.compactMap({ Alcohol(rawValue: $0) })
        self.matches = matches
        self.possibleMatches = possibleMatches
        self.rejectedUsers = rejectedUsers
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

enum Interests: String {
    case football
    case hockey
    case tennis
    case basketball
    case swimming
    case hiking
    case cycling
    case running
    case golf

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
