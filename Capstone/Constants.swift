//
//  Constants.swift
//  Capstone
//
//  Created by Angela Liu on 7/5/16.
//  Copyright © 2016 amliu. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

// These are constants used throughout the app

struct Constants {
    
    // -----------------------------------
    // User keywords (for getting)
    static let user_name:String = "name"
    static let user_japanese:String = "knowsJapanese"
    
    
    // -----------------------------------
    // Defaults for places, guides, pages
    static let defaultCategory:String = "none";
    static let defaultSubCategory:String = "none";
    static let defaultAddress:String = "300 South Craig Street, Pittsburgh, PA 15213";
    static let defaultPhone:String = "000-000-0000"
    static let defaultTags:[String] = ["none"]
    static let defaultOpenTime:String = "09:00"
    static let defaultCurrentTime:String = "13:00"
    static let defaultCloseTime:String = "18:00"
    static let defaultUrl:String = "http://odigo.travel"
    static let defaultTitle = "none"
    static let defaultDescription = "none"
    static let defaultUserLocation = CLLocation(latitude:40.4495946, longitude: -79.9509742)
    static let radiusForPlacesToDisplay: Float = 2000 // in meters
    static let notificationDelimiterRadius : CLLocationDistance = 5 // in meters
    
    // -----------------------------------
    // Global / Reused styling
    
    // Drop shadow
    static let shadowColor = UIColor.blackColor().CGColor
    static let shadowOpacity:Float = 0.25
    static let shadowRadius:CGFloat = 1.2
    static let shadowOffset = CGSize(width: 0.0, height: 3.0)
    
    
    // -----------------------------------
    // Card view styling
    static let card_height:CGFloat = 200 // Height of each card
    static let card_imageHeight:CGFloat = 100 // Height of image in a card
    static let card_textMargin: CGFloat = 10 // Space between text, image, and card edges within card
    static let card_textHeight: CGFloat = 50 // Height of text
    
    // -----------------------------------
    // Card list styling
    static let cardlist_margin:CGFloat = 10 // Space between cards in a list
    
    // -----------------------------------
    // Some useful regions to test notifications
    static let wesBancoRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 40.4541175,longitude: -79.9462548), radius: notificationDelimiterRadius, identifier: "WesBanco")
    static let ajayansHomeRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 40.4535864,longitude: -79.9461685), radius: notificationDelimiterRadius, identifier: "Home")
    static let mhciLabRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 40.4495946,longitude: -79.9509742), radius: notificationDelimiterRadius, identifier: "MHCILab")
    
}