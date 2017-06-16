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
    
    
    override func viewDidLoad() {
        subscribeForNotifications()
        super.viewDidLoad()
    }
    
    func subscribeForNotifications(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateUI),
                                               name: NSNotification.Name(rawValue: Utils.Notification.coordinatesAndCity),
                                               object: nil)
    }
    
    func unsubscribeFromNotifications(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Utils.Notification.coordinatesAndCity), object: nil)
    }
    
    func updateUI(notification: Notification){
        if let userInfo     = notification.userInfo   as? [String: Any] {
            let coordinates = userInfo["coordinates"] as! CLLocationCoordinate2D
            let city        = userInfo["city"]        as! String
            print(coordinates , city)
        }
    }
    
    deinit{
        unsubscribeFromNotifications()
    }

}
