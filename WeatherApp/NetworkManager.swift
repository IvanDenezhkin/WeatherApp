//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Ivan Denezhkin on 16.06.17.
//  Copyright © 2017 Ivan Denezhkin. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class NetworkManager{
    static let shared = NetworkManager()
    private let apiKey = "28f1b4ac7abe6965f39838bda855939e"
    private let baseURL = "http://api.openweathermap.org/data/2.5/weather"
    private let iconsURL = "http://openweathermap.org/img/w/"
    
    private init(){}
    
    func getWeatherData(forCoordinates coordinates: CLLocationCoordinate2D, completion: @escaping ((success: Bool,(temp: Double, description: String, icon: String)?))->()){
        let params: [String : Any] = ["lat"  : coordinates.latitude,
                                      "lon"  : coordinates.longitude,
                                      "units": "metric",
                                      "lang" : "ua",
                                      "APPID": apiKey]
        
        Alamofire.request(baseURL, method: .get, parameters: params).responseJSON { data in
            guard let jsonData = data.value else {completion((false,nil))
                                                  return }
            let json           = JSON(jsonData)
            let temperature    = json["main"]["temp"].doubleValue
            let iconName       = json["weather"][0]["icon"].stringValue
            let description    = json["weather"][0]["description"].stringValue
            completion((true,(temperature, description, iconName)))
        }
    }
    
    func getIcon(iconName: String, completion: @escaping (_ success: Bool, _ imageData: Data?) ->()){
        let url = iconsURL + iconName + ".png"
        Alamofire.request(url).responseData{ data in
            if let imageData = data.value{
                completion(true, imageData)
            } else {
                completion(false,nil)
            }
        }
    }
}
