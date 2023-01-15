//
//  AppStyles.swift
//  BeerBuddy
//
//  Created by Polina Tikhomirova on 12.01.2023.
//
// swiftlint: disable type_name
//

import UIKit

enum AppStyles {
    /// Application color
    enum color {
        static let sand = UIColor(hex: 0xDEAC8B),
                   swamp = UIColor(hex: 0x3D4632),
                   light = UIColor(hex: 0xF3EBE0),
                   brown = UIColor(hex: 0x734E33),
                   black = UIColor(hex: 0x000000),
                   offwhite = UIColor(hex: 0xFFFFFF)
    }
    /// Application size
    enum size {
        static var bigPadding: CGFloat { 50 }
        static var smallPadding: CGFloat { 10 }
        static var avatarWidth: CGFloat { 200 }
        static var avatarHeight: CGFloat { 230 }
    }
}
