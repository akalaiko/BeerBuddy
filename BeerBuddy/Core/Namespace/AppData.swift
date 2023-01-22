//
//  AppData.swift
//  BeerBuddy
//
//  Created by Ke4a on 10.01.2023.
//
// swiftlint:disable type_name
// swiftlint:disable nesting

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
    }
}

extension AppData {
    // MARK: - Screens

    /// Screen settings data.
    enum screen {
        enum main {
            /// Controllers to be added to the tab bar
            static var items: [(title: String, imageName: String, controller: () -> UIViewController)] {
                [
                    ("Match", AppData.imageName.beer, AppModuleBuilder.matchesController),
                    ("Map", AppData.imageName.matchBeer, AppModuleBuilder.testController),
                    ("Info", AppData.imageName.beer, AppModuleBuilder.testController),
                    ("Shop", AppData.imageName.matchBeer, AppModuleBuilder.testController)
                ]
            }
        }
    }
}
