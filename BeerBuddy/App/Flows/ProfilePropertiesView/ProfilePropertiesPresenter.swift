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
    private var locationManager: LocationManager?
    private var network: NetworkProtocol?
    
    // MARK: - Init
    
    init(locationManager: LocationManager?, network: NetworkProtocol?) {
        super.init()
        self.locationManager = locationManager
        self.network = network
    }
    
    // MARK: - Private methods
    
    private func getUserPhoto(safeEmail: String) {
        guard let path = network?.getProfilePicturePath(email: safeEmail) else { return }
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
    
    private func sendUserChanges() {
        guard let user = user else { return }
        network?.insertUser(with: user) { isSend in
            print(isSend)
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
        guard let safeEmail = network?.safeEmail(email: email) else { return }
        
        network?.getUser(with: safeEmail) { [weak self] result in
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
        guard
            let imageData = imageData,
            let user = user
        else { return }
        StorageManager.shared.uploadProfilePicture(with: imageData,
                                                   fileName: user.profilePictureFileName,
                                                   completion: { result in
            switch result {
            case .success(let downloadURL):
                UserDefaults.standard.set(downloadURL, forKey: "profile_picture_url")
                print(downloadURL)
            case .failure(let error):
                print(error)
            }
        })
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
        var newAlcoholArray = [Alcohol]()
        
        alcoholArray?.forEach({ alcohol in
            for alc in Alcohol.allCases where alc.rawValue == alcohol {
                newAlcoholArray.append(alc)
            }
        })
        user?.alcohols = newAlcoholArray
    }
    
    func changeInterests(interests: String?) {
        let interestsArray = interests?.components(separatedBy: " ")
        var newInterestsArray = [Interests]()
        
        interestsArray?.forEach({ interest in
            for inter in Interests.allCases where inter.rawValue == interest {
                newInterestsArray.append(inter)
            }
        })
        user?.interests = newInterestsArray
    }
    
    func changeDescribe(describe: String?) {
        sendUserChanges()
    }
}
