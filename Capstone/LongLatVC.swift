//
//  LongLatVC.swift
//  Capstone
//
//  Created by Katherine Habeck on 6/27/16.
//  Copyright © 2016 amliu. All rights reserved.
//

import Foundation
import UIKit
import Foundation
import CoreLocation

class LongLatVC: UIViewController, CLLocationManagerDelegate {
    
    
    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        startLocation = nil
        
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        var latestLocation: AnyObject = locations[locations.count - 1]
        
        print(String(format: "%.4f",
            latestLocation.coordinate.latitude))
        print(String(format: "%.4f",
            latestLocation.coordinate.longitude))
        print(String(format: "%.4f", latestLocation.horizontalAccuracy))
        print(String(format: "%.4f", latestLocation.altitude))
        
        
        if startLocation == nil {
            // TODO: Make this value accessible from the Places UI View
            startLocation = latestLocation as! CLLocation
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func locationManager(manager: CLLocationManager!,
                         didFailWithError error: NSError!) {
        
    }
    
}

