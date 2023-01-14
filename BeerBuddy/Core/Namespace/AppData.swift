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
    /// Names of the images added to the Assets.
    enum imageName {
        static var beer: String {
            "beer"
        }

        static var matchBeer: String {
            "matchBeer"
        }
        
        static var bearLogin: String {
            "bearLogin"
        }
        
        static var waveBackground: String {
            "waveBackground"
        }
    }

    /// Screens data for building.
    enum screen {
        /// An array of data tuple (button title, button image, controller) 
        static var main: [(title: String, imageName: String, controller: UIViewController.Type)] {
            [
                ("Match", AppData.imageName.beer, ViewController.self),
                ("Map", AppData.imageName.matchBeer, ViewController.self),
                ("Info", AppData.imageName.beer, ViewController.self),
                ("Shop", AppData.imageName.matchBeer, ViewController.self)
            ]
        }
    }
}
