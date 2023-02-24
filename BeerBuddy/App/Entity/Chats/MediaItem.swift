//
//  MediaItem.swift
//  BeerBuddy
//
//  Created by Tim on 22.02.2023.
//

import UIKit
import MessageKit

struct Media: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}
