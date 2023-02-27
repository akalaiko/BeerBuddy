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
                   lightDark = UIColor(hex: 0xEEE3D3),
                   brown = UIColor(hex: 0x734E33),
                   black = UIColor(hex: 0x000000),
                   offwhite = UIColor(hex: 0xFFFFFF)

        enum background {
            static var main: UIColor { light }
            static var pinnedChat: UIColor { lightDark }
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
            static var big: CGFloat { 48 }
        }

        enum height {
            static var header: CGFloat = UIScreen.main.bounds.height / 12
            static var footer: CGFloat { header }
            static var textfield: CGFloat { 56 }
            static var tableCell: CGFloat { 80 }
            static var minimalSize: CGFloat { UIScreen.main.bounds.height / 24 }
        }
    }
}

// MARK: - Font

extension AppStyles {
    /// Application font
    enum font {
        static var logo: UIFont = .systemFont(ofSize: 44, weight: .bold)
        static var button: UIFont = .systemFont(ofSize: 20, weight: .medium)
        static var big: UIFont = .systemFont(ofSize: 32, weight: .semibold)
        static var middle: UIFont = .systemFont(ofSize: 24, weight: .semibold)
        static var title: UIFont = .systemFont(ofSize: 32, weight: .semibold)
        static var username: UIFont = .systemFont(ofSize: 24, weight: .semibold)
        static var smallTextCell: UIFont = .systemFont(ofSize: 16, weight: .light)
        static var smallTextCard: UIFont =
            .systemFont(ofSize: 10, weight:
            .light)
        static var bigTextCard: UIFont = .systemFont(ofSize: 15, weight: .medium)

        enum pointSize {
            static var small: Double = 14
        }
    }
}

extension AppStyles {
    enum cornerRadius {
        static let textView: CGFloat = 10
    }
}
