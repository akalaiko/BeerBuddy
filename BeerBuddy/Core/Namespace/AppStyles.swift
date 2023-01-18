//
//  AppStyles.swift
//  BeerBuddy
//
//  Created by Polina Tikhomirova on 12.01.2023.
//
// swiftlint: disable type_name
// swiftlint: disable nesting

import UIKit

// MARK: - Color
enum AppStyles {
    /// Application color
    enum color {
        static let sand = UIColor(hex: 0xDEAC8B),
                   swamp = UIColor(hex: 0x3D4632),
                   light = UIColor(hex: 0xF3EBE0),
                   brown = UIColor(hex: 0x734E33),
                   black = UIColor(hex: 0x000000),
                   offwhite = UIColor(hex: 0xFFFFFF)

        enum background {
            static var main: UIColor { light }
        }
    }
}

// MARK: - Size

extension AppStyles {
    /// Application size
    enum size {
        /// Side padding.
        enum horizontalMargin {
            static var big: CGFloat { 48 }
            static var small: CGFloat { 8 }
            static var middle: CGFloat { 24 }
        }

        enum verticalMargin {
            static var small: CGFloat { 8 }
            static var middle: CGFloat { 24 }
        }

        enum height {
            static var header: CGFloat { 80 }
            static var textfield: CGFloat { 56 }
            static var tableCell: CGFloat { 80 }
        }
    }
}

// MARK: - Font

extension AppStyles {
    /// Application font
    enum font {
        static var logo: UIFont = .systemFont(ofSize: 44, weight: .bold)
        static var button: UIFont = .systemFont(ofSize: 20, weight: .medium)
        static var title: UIFont = .systemFont(ofSize: 32, weight: .semibold)
        static var username: UIFont = .systemFont(ofSize: 24, weight: .semibold)
    }
}
