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
    @IBOutlet weak var weatheView: UIView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
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
        weatheView.isHidden = true
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
        temperatureLabel.text = String(format: " %.0f˚", city.temperature!)
        weatherDescriptionLabel.text = city.weatherDescription
        NetworkManager.shared.getIcon(iconName: city.iconName) { data in
            guard let pictureData = data else { return }
                self.iconImageView.image = UIImage(data: pictureData)
                self.weatheView.isHidden = false
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
            NetworkManager.shared.getWeatherData(forCoordinates: coordinates){ tempTuple in
                if let tuple = tempTuple {
                    let newCity = City.init(name: city, coordinates: coordinates,
                                            temperature: tuple.temp, iconName: tuple.icon,
                                            weatherDescription: tuple.description)
                    self.currentCity = newCity
                }
            }
        }
    }
    
    deinit{
        unsubscribeFromNotifications()
    }

}
