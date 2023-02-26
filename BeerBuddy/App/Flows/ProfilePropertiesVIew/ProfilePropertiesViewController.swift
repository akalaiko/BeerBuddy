//
//  ProfilePropertiesViewController.swift
//  BeerBuddy
//
//  Created by Никита Мошенцев on 11.02.2023.
//

import UIKit
import CoreLocation

class ProfilePropertiesViewController: UIViewController {

    private var profilePropertiesView: ProfilePropertiesView {
        guard let view = self.view as? ProfilePropertiesView else {
            let correctView = ProfilePropertiesView()
            return correctView
        }
        
        return view
    }
    
    private let locationManager = CLLocationManager()
    
    var presenter: ProfilePropertiesViewOutput?
    
    // MARK: - Init
    
    init(presenter: ProfilePropertiesViewOutput) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = profilePropertiesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePropertiesView.configureUI()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        profilePropertiesView.addLocationButtonTarget(self, action: #selector(tappedLocationButton))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profilePropertiesView.subscribeObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        profilePropertiesView.unsubscribeObserver()
        locationManager.stopUpdatingLocation()
    }
}

extension ProfilePropertiesViewController: ProfilePropertiesViewInput {
    
}

// MARK: - Objc methods

extension ProfilePropertiesViewController {
    @objc func tappedLocationButton(sender: UIButton) {
        lookUpCurrentLocation { [weak self] place in
            print(place?.locality ?? "")
            self?.profilePropertiesView.setLocation(townName: place?.locality ?? "")
        }
    }
}

extension ProfilePropertiesViewController: CLLocationManagerDelegate {
//    private func checkLocation() {
//
//    let status = CLLocationManager.authorizationStatus()
//
//    // Handle each case of location permissions
//    switch status {
//    case .authorizedAlways:
//        print("authorizedAlways")
//    case .authorizedWhenInUse:
//        print("authorizedWhenInUse")
//    case .denied:
//        print("denied")
//    case .notDetermined:
//        print("notDetermined")
//    case .restricted:
//        print("restricted")
//    }
//}
    
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
                    -> Void ) {
        // Use the last reported location.
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder()
                
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation, completionHandler: { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?[0]
                    completionHandler(firstLocation)
                } else {
                 // An error occurred during geocoding.
                    completionHandler(nil)
                }
            })
        } else {
            // No location was available.
            completionHandler(nil)
        }
    }
}
