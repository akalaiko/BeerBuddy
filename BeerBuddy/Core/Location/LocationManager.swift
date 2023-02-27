//
//  Location.swift
//  BeerBuddy
//
//  Created by Никита Мошенцев on 26.02.2023.
//

import CoreLocation
import Foundation

final class LocationManager: NSObject {
    
    // MARK: - Private properties
    
    private let locationManager = CLLocationManager()
    
    func setDelegateLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override init() {
        super.init()
        self.setDelegateLocation()
    }
    
    // MARK: - Methods
    
    func stopUpdateLocation() {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    /// Get city from location
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?) -> Void ) {
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(lastLocation, completionHandler: { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?[0]
                    completionHandler(firstLocation)
                } else {
                    completionHandler(nil)
                }
            })
        } else {
            completionHandler(nil)
        }
    }
}
