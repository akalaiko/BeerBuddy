//
//  UserModel.swift
//  BeerBuddy
//
//  Created by Polina Tikhomirova on 10.01.2023.
//

import UIKit

struct UserModel {
    let firstName: String
    let lastName: String
    let username: String
    var matches: [UserModel]
    let sex: Sex
    let birthDate: Date
    var age: Int {
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: now)
        return ageComponents.year!
    }
    var interests: [Interests]
    var favAlcohol: [Alcohol]
}

enum Sex {
    case male
    case female
}

indirect enum Interests {
    case Sport(Sport)
    case Music(Music)
    case Movies(Movies)
}

enum Sport {
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

enum Music {
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

enum Movies {
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

enum Alcohol {
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
}


