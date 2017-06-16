//
//  City.swift
//  WeatherApp
//
//  Created by Ivan Denezhkin on 16.06.17.
//  Copyright © 2017 Ivan Denezhkin. All rights reserved.
//

import Foundation
import CoreLocation

class City{
    let name: String!
    let coordinates: CLLocationCoordinate2D?
    let temperature: Double?
    let iconName: String?
    
    init(name: String, coordinates: CLLocationCoordinate2D, temperature: Double, iconName: String){
        self.name = name
        self.coordinates = coordinates
        self.temperature = temperature
        self.iconName = iconName
    }
}
