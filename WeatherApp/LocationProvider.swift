//
//  LocationProvider.swift
//  WeatherApp
//
//  Created by Ivan Denezhkin on 16.06.17.
//  Copyright © 2017 Ivan Denezhkin. All rights reserved.
//

import UIKit
import CoreLocation

class LocationProvider: NSObject {
    static let shared           = LocationProvider()
    fileprivate var isFirstTime = true
    private let locationManager = CLLocationManager()
    
    private override init() {
        super.init()
        setup()
    }
    
    func updateLocation(){
        isFirstTime = true
        locationManager.startUpdatingLocation()
    }
    
    fileprivate func setup(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    fileprivate func getCityName(fromLocation location: CLLocation){
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            guard let addressDict = placemarks?.first?.addressDictionary else { return }
            
            if let city = addressDict["City"] as? String {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Utils.Notification.coordinatesAndCity),
                                                object: nil,
                                                userInfo: ["city": city , "coordinates": location.coordinate])
            }
        })
    }
}

extension LocationProvider: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.first != nil && isFirstTime {
            isFirstTime = false
            manager.stopUpdatingLocation()
            getCityName(fromLocation: locations.first!)
        }
    }
}
