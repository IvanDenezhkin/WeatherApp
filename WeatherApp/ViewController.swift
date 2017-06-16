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
    
    let locationProvider = LocationProvider.shared
    var refreshControl: UIRefreshControl!
    var currentCity: City?{
        didSet{
           print(currentCity?.name)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeForNotifications()
        setRefreshControl()
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
            print(city)
            NetworkManager.shared.getWeatherData(forCoordinates: coordinates){ tempTuple in
                let newCity = City.init(name: city, coordinates: coordinates, temperature: tempTuple.temp, iconName: tempTuple.icon)
                self.currentCity = newCity
            }
        }
    }
    
    deinit{
        unsubscribeFromNotifications()
    }

}
