//
//  ProfilePropertiesPresenter.swift
//  BeerBuddy
//
//  Created by Никита Мошенцев on 11.02.2023.
//

import Foundation
import UIKit

protocol ProfilePropertiesViewInput: AnyObject {
}

protocol ProfilePropertiesViewOutput: AnyObject {
}

final class ProfilePropertiesPresenter {
    weak var viewController: (UIViewController & ProfilePropertiesViewInput)?
}

extension ProfilePropertiesPresenter: ProfilePropertiesViewOutput {
    
}
