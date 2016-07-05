//
//  Place.swift
//
//  Created by Angela Liu on 6/27/16.
//  Copyright © 2016 amliu. All rights reserved.
//

import Foundation
import CoreLocation

// Encapsulates information about spots, and converts data into a form presentable in the UIViews
class Place {
    
    var id:Int // unique identifier for a place
    var name: String
    var location: CLLocation // latitude and longitude wrapped in a CLLocation type
    var category: String?
    var subcategory: String?
    var address: String?
    var phone: String?
    var openingHour: Int?
    var openingMinute: Int?
    var closingHour:Int?
    var closingMinute:Int?
    var image_url: String?
    var tags: [String]?

    init?(id: Int, longitude: Float, latitude: Float, category: String?, subcategory: String?, name: String, address: String?, phone: String?, open_hour: String?, close_hour: String?, image_url: String?, tags: String?) {
        
        self.id = id
        location = CLLocation(latitude:CLLocationDegrees(latitude), longitude:CLLocationDegrees(longitude))
        self.name = name;
        
        self.category = initializeStringValue(category, defaultValue: Constants.defaultCategory)
        self.subcategory = initializeStringValue(subcategory, defaultValue: Constants.defaultSubCategory)
        self.address = initializeStringValue(address, defaultValue: Constants.defaultAddress)
        self.phone = initializeStringValue(phone, defaultValue:Constants.defaultPhone)
        
        self.tags = initializeStringArrayValue(tags,defaultValue:Constants.defaultTags);
        
        let openingHourArray = initializeTimeValue(open_hour, defaultTimeValue:Constants.defaultOpenTime)
        self.openingHour = (Int)(openingHourArray[0])!
        self.openingMinute = (Int)(openingHourArray[1])!
        
        let closingHourArray = initializeTimeValue(close_hour, defaultTimeValue:Constants.defaultCloseTime)
        self.closingHour = (Int)(closingHourArray[0])!
        self.closingMinute = (Int)(closingHourArray[1])!
        
        self.image_url = initializeStringValue(image_url, defaultValue:Constants.defaultUrl)
        
    }
    
    // Takes in the user's current location and returns distance from this place
    func getDistanceFromUser(userLocation:CLLocation) -> CLLocationDistance {
        return self.location.distanceFromLocation(userLocation);
    }
    
    // TODO: Add a check to test that particular type of attribute - varchar vs char for example
    /**
        Takes in a value intended to be assigned and force unwraps it. If nil assigns a default value
     */
    private func initializeStringValue(assignedValue:String?, defaultValue:String) -> String
    {
        if let val = assignedValue {
            return val
        }
        else
        {
            return defaultValue
        }
    }
    
    func initializeStringArrayValue(assignedValue:String?, defaultValue:[String]) -> [String]
    {
        if let val = assignedValue {
            return val.componentsSeparatedByString(",")
        }
        else {
            return defaultValue;
        }
    }
    
    // assumes that the timeString is already correctly formatted
    func initializeTimeValue(timeString:String?, defaultTimeValue:String) -> [String]
    {
        if timeString != nil {
            return timeString!.componentsSeparatedByString(":")
        }
        else {
            return defaultTimeValue.componentsSeparatedByString(":")
        }
    }
    
    
    func getIsPlaceOpen() -> Bool
    {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute], fromDate: date)
        let currentHour = components.hour
        let currentMinute = components.minute
        
        if currentHour < openingHour || currentHour > closingHour {
            return false;
        }
        else if currentHour == openingHour {
            return currentMinute >= openingMinute
        }
        
        else if currentHour == closingHour {
            return currentMinute <= closingMinute
        }
        
        return true;
    }
    
    func testParams() {
        
        print(String(id) + "\n")
        print(name + "\n")
        // print(getDistanceFromUser(self.location)) -> Need user's location for this
        print(category! + "\n")
        print(subcategory! + "\n")
        print(address! + "\n")
        print(phone! + "\n")
        print(String(openingHour!) + "\n")
        print(String(openingMinute!) + "\n")
        print(String(closingHour!) + "\n")
        print(String(closingMinute!) + "\n")
        print(image_url! + "\n")
        print(tags!)
    }
}