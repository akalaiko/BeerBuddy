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
    func setUserProperties(user: User)
    func setAvatarImage(avatarData: Data)
    func addAlcohol(_ alcohol: String)
    func removeAlcohol(_ alcohol: String)
    func updateAlcohol(alcohol: [Alcohol])
    func addInterest(_ interest: String)
    func removeInterest(_ interest: String)
    func updateInterests(interests: [Interests])
    func changePhoto(image: UIImage?)
    func changeName(name: String?)
    func changeBirthdaDate(date: Date?)
    func changeLocation(location: String?)
    func changeGender(gender: Int?)
    func changeSmoking(smoking: Int?)
    func changeAlcohol(alcohol: String?)
    func changeInterests(interests: String?)
    func changeDescribe(describe: String?)
}

// MARK: - ProfilePropertiesViewOutput

protocol ProfilePropertiesViewOutput: AnyObject {
    func getCityName()
    func stopLocationUpdate()
    func getUserModel()
    func addAlcoholPreference(_ alcohol: String)
    func removeAlcohol(_ alcohol: String)
    func addInterestPreference(_ interest: String)
    func removeInterest(_ interest: String)
    func changePhoto(image: UIImage?)
    func changeName(name: String?)
    func changeBirthdaDate(date: Date?)
    func changeLocation(location: String?)
    func changeGender(gender: Int?)
    func changeSmoking(smoking: Int?)
    func changeAlcohol(alcohol: String?)
    func changeInterests(interests: String?)
    func changeDescribe(describe: String?)
}

final class ProfilePropertiesPresenter: NSObject {
    
    // MARK: - Properties
    
    private var user: User?
    
    weak var viewController: (UIViewController & ProfilePropertiesViewInput)?
    var locationManager: LocationManager?
    
    // MARK: - Init
    
    init(locationManager: LocationManager?) {
        super.init()
        self.locationManager = locationManager
    }
    
    // MARK: - Private methods
    private func getUserPhoto(safeEmail: String) {
        let path = DatabaseManager.getProfilePicturePath(email: safeEmail)
        StorageManager.shared.downloadURL(for: path) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let urlString):
                guard let url = URL(string: urlString) else { return }
                StorageManager.shared.downloadImage(from: url) { avatarData in
                    self.viewController?.setAvatarImage(avatarData: avatarData)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - ProfilePropertiesViewOutput

extension ProfilePropertiesPresenter: ProfilePropertiesViewOutput {
    
    func addInterestPreference(_ interest: String) {
        for interestInEnum in Interests.allCases where interestInEnum.rawValue.lowercased() == interest.lowercased() {
            user?.interests.append(interestInEnum)
        }
        guard let interests = user?.interests else { return }
        viewController?.updateInterests(interests: interests)
    }
    
    func removeInterest(_ interest: String) {
        guard let interests = user?.interests else { return }
        for (index, element) in interests.enumerated() where element.rawValue.lowercased() == interest.lowercased() {
            user?.interests.remove(at: index)
        }
        viewController?.updateInterests(interests: user?.interests ?? [Interests.pop])
    }
    
    func getUserModel() {
        let email = UserDefaults.standard.value(forKey: "email") as? String
        let safeEmail = DatabaseManager.safeEmail(email: email)
        
        DatabaseManager.shared.getUser(with: safeEmail) { [weak self] result in
            switch result {
            case .success(let user):
                self?.getUserPhoto(safeEmail: safeEmail)
                self?.user = user
                self?.viewController?.setUserProperties(user: user)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
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
        for alcoholInEnum in Alcohol.allCases where alcoholInEnum.rawValue.lowercased() == alcohol.lowercased() {
            user?.alcohols.append(alcoholInEnum)
        }
        guard let alcohols = user?.alcohols else { return }
        viewController?.updateAlcohol(alcohol: alcohols)
    }
    
    func removeAlcohol(_ alcohol: String) {
        guard let alcohols = user?.alcohols else { return }
        for (index, element) in alcohols.enumerated() where element.rawValue.lowercased() == alcohol.lowercased() {
            user?.alcohols.remove(at: index)
        }
        viewController?.updateAlcohol(alcohol: user?.alcohols ?? [Alcohol.noDrinking])
    }
    
    func changePhoto(image: UIImage?) {
        let imageData = image?.pngData()
    }
    
    func changeName(name: String?) {
        guard let newName = name else { return }
        if user?.name != newName {
            user?.name = newName
        } else {
            return
        }
    }
    
    func changeBirthdaDate(date: Date?) {
        guard let newDate = date?.timeIntervalSince1970 else { return }
        if user?.birthDate != newDate {
            user?.birthDate = newDate
        } else {
            return
        }
    }
    
    func changeLocation(location: String?) {
        guard let newLocation = location else { return }
        if user?.location != newLocation {
            user?.location = newLocation
        } else {
            return
        }
    }
    
    func changeGender(gender: Int?) {
        guard let newGender = gender else { return }
        
        if newGender == 0 {
            user?.sex = .male
        } else if newGender == 1 {
            user?.sex = .female
        } else if newGender == 2 {
            user?.sex = .other
        } else {
            user?.sex = .other
        }
    }
    
    func changeSmoking(smoking: Int?) {
        guard let newSmoking = smoking else { return }
        
        if newSmoking == 0 {
            user?.smoking = .smoking
        } else if newSmoking == 1 {
            user?.smoking = .ok
        } else if newSmoking == 2 {
            user?.smoking = .noSmoking
        } else {
            user?.smoking = .noSmoking
        }
    }
    
    func changeAlcohol(alcohol: String?) {
        let alcoholArray = alcohol?.components(separatedBy: " ")
        
    }
    
    func changeInterests(interests: String?) {
        print(1)
    }
    
    func changeDescribe(describe: String?) {
        print(1)
    }
}
