//
//  UIColor+Extensions.swift
//  BeerBuddy
//
//  Created by Polina Tikhomirova on 12.01.2023.
//

import UIKit

struct AppColors {
    static let sand = UIColor(hex: 0xDEAC8B)
    static let swamp = UIColor(hex: 0x3D4632)
    static let light = UIColor(hex: 0xF3EBE0)
    static let brown = UIColor(hex: 0x734E33)
    static let black = UIColor(hex: 0x000000)
    static let offwhite = UIColor(hex: 0xFFFFFF)
}

extension UIColor {
    convenience init(
        hex: UInt,
        alpha: CGFloat = 1
    ) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha)
    }
}


