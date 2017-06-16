//
//  ViewControllerExtentions.swift
//  WeatherApp
//
//  Created by Ivan Denezhkin on 17.06.17.
//  Copyright © 2017 Ivan Denezhkin. All rights reserved.
//

import UIKit

extension UIViewController{
    
    func pushAlert(text: String){
        let alert = UIAlertController(title: "", message: text, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    }
