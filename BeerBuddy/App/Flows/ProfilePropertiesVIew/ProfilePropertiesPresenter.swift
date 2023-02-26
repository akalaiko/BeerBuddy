//
//  ProfilePropertiesPresenter.swift
//  BeerBuddy
//
//  Created by Никита Мошенцев on 11.02.2023.
//

import Foundation
import UIKit

protocol ProfilePropertiesViewInput: AnyObject {
    func setCityName(cityName: String)
    func showAlertController()
}

protocol ProfilePropertiesViewOutput: AnyObject {
    func getCityName()
    func stopLocationUpdate()
    func getUserModel() -> User?
}

final class ProfilePropertiesPresenter: NSObject {
    weak var viewController: (UIViewController & ProfilePropertiesViewInput)?
    var locationManager: LocationManager?
    
    private var userModel: User?
    
    init(locationManager: LocationManager?, userModel: User?) {
        super.init()
        self.locationManager = locationManager
        self.userModel = userModel
    }
}

extension ProfilePropertiesPresenter: ProfilePropertiesViewOutput {
    func getCityName() {
        locationManager?.lookUpCurrentLocation { [weak self] place in
            guard let cityName = place?.locality else {
                self?.viewController?.showAlertController()
                return
            }
            self?.viewController?.setCityName(cityName: cityName)
        }
    }
    
    func stopLocationUpdate() {
        locationManager?.stopUpdateLocation()
    }
    
    func getUserModel() -> User? {
        guard
            let userModel = userModel
        else {
            return nil
            
        }
        return userModel
    }
}
