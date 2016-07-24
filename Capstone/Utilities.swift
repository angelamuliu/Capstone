//
//  Utilities.swift
//  Capstone
//
//  Created by Ajayan Subramanian on 7/10/16.
//  Copyright © 2016 amliu. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

/* methods that could be useful throughout the app and should not be repeated at each occurence */
class Utilities
{
    // returns current time in HH:mm
    static func getCurrentTime() -> String
    {
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.stringFromDate(date)
    }
    
    static func getCurrentHoursAndMin() -> [Int]
    {
        var time: [Int]
        time = []
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute], fromDate: date)
        time.append(components.hour)
        time.append(components.minute)
        return time
    }
    
    // temp places created for in case database fails
    static func getTempPlaces() -> [Place]
    {
        var places : [Place]
        places = []
        for index in 1...10 {
            let place = Place(id: index, longitude: (Float(Constants.defaultUserLocation.coordinate.longitude) + Float(index)), latitude: (Float(Constants.defaultUserLocation.coordinate.latitude) + Float(index)), category: Constants.defaultCategory, subcategory:Constants.defaultSubCategory, name: ("Place" + String(index)), address: Constants.defaultAddress, phone: Constants.defaultPhone, open_hour: Constants.defaultOpenTime, close_hour: Constants.defaultCloseTime, image_url: Constants.defaultUrl, tags: "tag")
            
            let guide = Guide(id: index, title: "howto", category: "asd", subcategory: "asd", hidden: false, image_url: "asd")
            place!.guides = []
            place!.guides!.append(guide)
            places.append(place!)
        }
        
        // hardcoding some values for testing geofencing
        
        places[0].name = Constants.wesBancoRegion.identifier
        places[1].name = Constants.ajayansHomeRegion.identifier
        places[2].name = Constants.mhciLabRegion.identifier
        places[0].location = CLLocation(latitude: Constants.wesBancoRegion.center.latitude, longitude: Constants.wesBancoRegion.center.longitude)
        places[0].location = CLLocation(latitude: Constants.ajayansHomeRegion.center.latitude, longitude: Constants.ajayansHomeRegion.center.longitude)
        places[0].location = CLLocation(latitude: Constants.mhciLabRegion.center.latitude, longitude: Constants.mhciLabRegion.center.longitude)
        places[2].tags = ["temple","tag1", "tag2"]
        
        
        return places
    }
}