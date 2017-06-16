//
//  ViewController.swift
//  WeatherApp
//
//  Created by Ivan Denezhkin on 16.06.17.
//  Copyright © 2017 Ivan Denezhkin. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var WeatherView: UIView!
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    
    let locationProvider = LocationProvider.shared
    var refreshControl: UIRefreshControl!
    
    var currentCity: City?{
        didSet{
           self.updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeForNotifications()
        setRefreshControl()
        presets()
    }
    
    func presets(){
        WeatherView.isHidden = true
        ActivityIndicator.startAnimating()
    }
    
    func setRefreshControl(){
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(updateData), for: UIControlEvents.valueChanged)
        scrollView.addSubview(refreshControl)
    }
    
    func updateData(sender:AnyObject){
        locationProvider.updateLocation()
        refreshControl.endRefreshing()
    }
    
    func updateUI(){
        guard let city = currentCity else { return }
        cityNameLabel.text = city.name
        temperatureLabel.text = String(format: " %.0f˚ ", city.temperature!)
        weatherDescriptionLabel.text = city.weatherDescription
        
        NetworkManager.shared.getIcon(iconName: city.iconName) { success, data in
            if success {
            guard let pictureData = data else { return }
                self.iconImageView.image = UIImage(data: pictureData)
                self.WeatherView.isHidden = false
                self.ActivityIndicator.stopAnimating()
            }else {
                self.pushAlert(text: "No connection")
            }
        }
    }
    
    func subscribeForNotifications(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateCity),
                                               name: NSNotification.Name(rawValue: Utils.Notification.coordinatesAndCity),
                                               object: nil)
    }
    
    func unsubscribeFromNotifications(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Utils.Notification.coordinatesAndCity), object: nil)
    }
    
    func updateCity(notification: Notification){
        if let userInfo     = notification.userInfo   as? [String: Any] {
            let coordinates = userInfo["coordinates"] as! CLLocationCoordinate2D
            let city        = userInfo["city"]        as! String
            
            NetworkManager.shared.getWeatherData(forCoordinates: coordinates){ success, tempTuple in
                if success {
                    guard let tuple = tempTuple else { return }
                    let newCity = City.init(name: city, coordinates: coordinates,
                                            temperature: tuple.temp, iconName: tuple.icon,
                                            weatherDescription: tuple.description)
                    self.currentCity = newCity
                } else {
                    self.pushAlert(text: "Something goes wrong")
                }
            }
        }
    }
    
    deinit{
        unsubscribeFromNotifications()
    }

}
