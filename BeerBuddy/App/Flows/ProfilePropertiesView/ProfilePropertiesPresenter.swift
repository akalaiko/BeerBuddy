//
//  ProfilePropertiesPresenter.swift
//  BeerBuddy
//
//  Created by Никита Мошенцев on 11.02.2023.
//

import Foundation
import UIKit

// MARK: - ProfilePropertiesViewInput

protocol ProfilePropertiesViewInput: AnyObject {
    func setCityName(cityName: String)
    func showAlertController()
    func addAlcohol(_ alcohol: String)
    func removeAlcohol(_ alcohol: String)
    func updateAlcohol(alcohol: [Alcohol])
    func addInterest(_ interest: String)
    func removeInterest(_ interest: String)
    func updateInterests(interests: [Interests])
}

// MARK: - ProfilePropertiesViewOutput

protocol ProfilePropertiesViewOutput: AnyObject {
    func getCityName()
    func stopLocationUpdate()
    func getUserModel() -> User
    func addAlcoholPreference(_ alcohol: String)
    func removeAlcohol(_ alcohol: String)
    func addInterestPreference(_ interest: String)
    func removeInterest(_ interest: String)
}

final class ProfilePropertiesPresenter: NSObject {
    
    // MARK: - Properties
    
    private var user: User?
    
    weak var viewController: (UIViewController & ProfilePropertiesViewInput)?
    var locationManager: LocationManager?
    
    // MARK: - Init
    
    init(locationManager: LocationManager?, userModel: User?) {
        super.init()
        self.locationManager = locationManager
        self.user = userModel
    }
    
    // MARK: - Private methods
    
}

// MARK: - ProfilePropertiesViewOutput

extension ProfilePropertiesPresenter: ProfilePropertiesViewOutput {
    func addInterestPreference(_ interest: String) {
        for interestInEnum in Interests.allCases {
            if interestInEnum.rawValue.lowercased() == interest.lowercased() {
                user?.interests.append(interestInEnum)
            }
        }
        guard let interests = user?.interests else { return }
        viewController?.updateInterests(interests: interests)
    }
    
    func removeInterest(_ interest: String) {
        guard let interests = user?.interests else { return }
        for (index, element) in interests.enumerated() {
            if element.rawValue.lowercased() == interest.lowercased() {
                user?.interests.remove(at: index)
            }
        }
        viewController?.updateInterests(interests: user?.interests ?? [Interests.pop])
    }

    func getUserModel() -> User {
        DatabaseManager.shared.getUser(with: DatabaseManager.sa, completion: <#T##(Result<User, Error>) -> Void#>)
        return user ?? User(name: "", emailAddress: "")
    }
    
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
    
    func addAlcoholPreference(_ alcohol: String) {
        for alcoholInEnum in Alcohol.allCases {
            if alcoholInEnum.rawValue.lowercased() == alcohol.lowercased() {
                user?.alcohols.append(alcoholInEnum)
            }
        }
        guard let alcohols = user?.alcohols else { return }
        viewController?.updateAlcohol(alcohol: alcohols)
    }
    
    func removeAlcohol(_ alcohol: String) {
        guard let alcohols = user?.alcohols else { return }
        for (index, element) in alcohols.enumerated() {
            if element.rawValue.lowercased() == alcohol.lowercased() {
                user?.alcohols.remove(at: index)
            }
        }
        viewController?.updateAlcohol(alcohol: user?.alcohols ?? [Alcohol.noDrinking])
    }
}
