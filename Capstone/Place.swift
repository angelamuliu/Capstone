//
//  Place.swift
//
//  Created by Angela Liu on 6/27/16.
//  Copyright © 2016 amliu. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

// Encapsulates information about spots, and converts data into a form presentable in the UIViews
class Place : MiniCardable {
    
    var id:Int // unique identifier for a place
    var name: String
    var location: CLLocation // latitude and longitude wrapped in a CLLocation type
    var category: String
    var subcategory: String?
    var address: String?
    var phone: String?
    var openingHour: Int?
    var openingMinute: Int?
    var closingHour:Int?
    var closingMinute:Int?
    var image_url: String?
    var tags: [String]?
    
    var related_guides:[Guide] = [] // Connected guides

    init?(id: Int, longitude: Float, latitude: Float, category: String?, subcategory: String?, name: String, address: String?, phone: String?, open_hour: String?, close_hour: String?, image_url: String?, tags: String?) {
        self.id = id
        
        print(name)
        print(latitude)
        print(longitude)
        
        
        self.location = CLLocation(latitude:CLLocationDegrees(latitude), longitude:CLLocationDegrees(longitude))
        
        print(location.coordinate)
        
        self.name = name
        
        self.category = Place.initializeStringValue(category, defaultValue: Constants.defaultCategory)
        self.subcategory = Place.initializeStringValue(subcategory, defaultValue: Constants.defaultSubCategory)
        self.address = Place.initializeStringValue(address, defaultValue: Constants.defaultAddress)
        self.phone = Place.initializeStringValue(phone, defaultValue:Constants.defaultPhone)
        
        self.tags = initializeStringArrayValue(tags,defaultValue:Constants.defaultTags);
        
        let openingHourArray = initializeTimeValue(open_hour, defaultTimeValue:Constants.defaultOpenTime)
        self.openingHour = (Int)(openingHourArray[0])!
        self.openingMinute = (Int)(openingHourArray[1])!
        
        let closingHourArray = initializeTimeValue(close_hour, defaultTimeValue:Constants.defaultCloseTime)
        self.closingHour = (Int)(closingHourArray[0])!
        self.closingMinute = (Int)(closingHourArray[1])!
        
        self.image_url = Place.initializeStringValue(image_url, defaultValue:Constants.defaultUrl)
    }
    
    /* Takes in the user's current location and returns distance from this place in meters
     this is intentionally a method and not a boolean member to avoid stale data */
    func getDistanceFromUser(userLocation:CLLocation) -> CLLocationDistance {
        return self.location.distanceFromLocation(userLocation)
    }
    
    var guides : [Guide] {
        get {
            if related_guides.isEmpty {
                guard let db = try? SQLiteDatabase.open() else
                {
                    print("Database did not load. Using failsafe hardcoded values for now.")
                    return []
                }
                related_guides = db.getGuidesForPlace(self)
                db.close()
            }
            return related_guides
        }
        set {
            related_guides = guides
        }
    }
    
    
    // TODO: Not make it milatary time haha
    var hours : String {  //computed property, relies on other stuff to get set
        get {
            return "\(openingHour!):\(openingMinute!) - \(closingHour!):\(closingMinute!)"
        }
    }
    
    // Goes straight to getting location from app Delegate so we don't have to somehow pass it in
    var distance : CLLocationDistance? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let userPosition = appDelegate.lastLocation
        if userPosition != nil {
            return getDistanceFromUser(userPosition!)
        } else {
            return nil
        }
    }
    
    // TODO: Add a check to test that particular type of attribute - varchar vs char for example
    /**
        Takes in a value intended to be assigned and force unwraps it. If nil assigns a default value
     */
    private static func initializeStringValue(assignedValue:String?, defaultValue:String) -> String
    {
        if let val = assignedValue {
            return val
        }
        else
        {
            return defaultValue
        }
    }
    
    private func initializeStringArrayValue(assignedValue:String?, defaultValue:[String]) -> [String]
    {
        if let val = assignedValue {
            return val.componentsSeparatedByString(",")
        }
        else {
            return defaultValue;
        }
    }
    
    // assumes that the timeString is already correctly formatted
    private func initializeTimeValue(timeString:String?, defaultTimeValue:String) -> [String]
    {
        if timeString != nil {
            return timeString!.componentsSeparatedByString(":")
        }
        else {
            return defaultTimeValue.componentsSeparatedByString(":")
        }
    }
    
    /* this is intentionally a method and not a boolean member to avoid stale data */
    func getIsPlaceOpen() -> Bool
    {
        let currentHour = Utilities.getCurrentHoursAndMin()[0]
        let currentMinute = Utilities.getCurrentHoursAndMin()[1]
        
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
    
    /* takes in a lowercase search term. Currently checks whether this string is part of the following attributes: name, category, subcategory,tags */
    func containsKeyword(searchTerm: String) -> Bool
    {
        var returnVal = false
        
        // optimization to prevent unneccessary search for 2 characters, example 'th'
        if searchTerm.characters.count >= 3
        {
            if name.lowercaseString.containsString(searchTerm) || category.lowercaseString.containsString(searchTerm) || subcategory!.lowercaseString.containsString(searchTerm)
            {
                returnVal = true
            }
            else
            {
                for tag in tags!
                {
                    if tag.lowercaseString.containsString(searchTerm)
                    {
                        returnVal = true
                        break
                    }
                }
            }
        }
        return returnVal
    }
    
    /* A test method to print all the members, ensuring that Place is initialized properly */
    func testParams() {
        print("ID:" + String(id) + "\n")
        print("Name:" + name + "\n")
        // print(getDistanceFromUser(self.location)) -> Need user's location for this
        print("Category:" + category + "\n")
        print("Subcategory:" + subcategory! + "\n")
        print("Address:" + address! + "\n")
        print("Phone:" + phone! + "\n")
        print("Opening Hour:" + String(openingHour!) + "\n")
        print("Opening Minute:" + String(openingMinute!) + "\n")
        print("Closing Hour:" + String(closingHour!) + "\n")
        print("Closing Minute:" + String(closingMinute!) + "\n")
        print("Open:" + String(getIsPlaceOpen()) + "\n")
        print(image_url! + "\n")
        print(tags!)
    }
    
    
    
    // Implementing minicardable
    var minicardTitle: String {
        get { return name }
    }
    var cardImage: UIImage? {
        get { return (UIImage(named: self.image_url!)) }
    }
    var categoryImage: UIImage? { // TODO: Make this not default to a present icon
        get { return UIImage(named: "category-present-icon")! }
    }
    var additionalText: String? { // TODO: Make this actually calculate distance from the user
        get {
            if distance != nil {
                return  "\(Int(distance!)) m"
            } else {
                return ""
            }
        }
    }
    

}