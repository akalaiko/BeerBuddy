//
//  Location.swift
//  BeerBuddy
//
//  Created by Tim on 22.02.2023.
//

import CoreLocation
import Foundation
import MessageKit

struct Location: LocationItem {
    var location: CLLocation
    var size: CGSize
}
