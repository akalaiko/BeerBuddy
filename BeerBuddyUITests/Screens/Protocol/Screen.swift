//
//  Screen.swift
//  BeerBuddyUITests
//
//  Created by Ke4a on 09.02.2023.
//

import XCTest

protocol Screen {
    var app: XCUIApplication { get }
    func verifyElements()
}
