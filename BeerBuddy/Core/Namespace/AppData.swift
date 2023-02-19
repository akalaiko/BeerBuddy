//
//  AppData.swift
//  BeerBuddy
//
//  Created by Ke4a on 10.01.2023.
//
// swiftlint:disable type_name

import Foundation
import UIKit

/// Application data.
enum AppData {
    // MARK: - Images
    
    /// Names of the images added to the Assets.
    enum imageName {
        static var beer: String { "beer" }
        static var matchBeer: String { "matchBeer" }
        static var bearLogin: String { "bearLogin" }
        static var waveBackground: String { "waveBackground" }
        static var missingPhoto: String { "missingPhoto" }
        static var location: String { "location" }
        static var noSmoking: String { "noSmoking" }
        static var noDrinking: String { "noDrinking" }
        static var testAvatar: String { "avatar" }
        static var slider: String { "slider" }
        static var search: String { "magnifyingGlass" }
        static var message: String { "message" }
        static var settings: String { "gear" }
        static var mapIcon: String { "mapIcon" }
    }
}
