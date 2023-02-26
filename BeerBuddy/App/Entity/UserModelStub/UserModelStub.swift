//
//  UserModelStub.swift
//  BeerBuddy
//
//  Created by Ke4a on 09.02.2023.
//

import Foundation

// FIXME: Only for tests, remove after connecting firebase.

struct UserModelStub {
    let id: Int
    let username: String = UserModelStub.names.randomElement() ?? "Error name"
    let age: Int = Int.random(in: 18...79)
    let location: String = UserModelStub.locations.randomElement() ?? "Error location"
    let noSmoking: Bool = Bool.random()
    let noDrinking: Bool = Bool.random()

    static var names: [String] {
        ["Valentina", "Jacques", "Guillermo",
         "Freddie", "Jaela", "Aden",
         "Viviana", "Leyla", "Priscila"]
    }

    static var locations: [String] {
        ["Moscow Red Square", "Berlin Brandenburg Gate", "Kazan Kremlin" ]
    }
}

struct ChatAppUser {
    
    let name: String
    let emailAddress: String
    
    var safeEmail: String {
        var email = emailAddress.replacingOccurrences(of: ".", with: "-")
        email = email.replacingOccurrences(of: "@", with: "-")
        return email
    }
    
    var profilePictureFileName: String {
        return "\(safeEmail)_profile_picture.png"
    }
}
