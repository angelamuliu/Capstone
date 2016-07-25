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
    
    static let dbpath = NSBundle.mainBundle().pathForResource("db", ofType: "sqlite")
    
    static let locationChange_EventName = "Location Changed"
    
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
    static let locationDistanceFilter:Double = 10
    
    // -----------------------------------
    // Global / Reused styling
    
    // Colors
    static let gold = UIColor(red: 245.0/255, green:166.0/255, blue:35.0/255, alpha: 1) // #F5A623
    static let navy = UIColor(red:24.0/255, green:123.0/255, blue:191.0/255, alpha: 1) // #237BBF
    static let grey = UIColor(red: 155.0/255, green: 155.0/255, blue: 155.0/255, alpha: 1) //#9b9b9b
    static let snow = UIColor(red: 235.0/255, green: 235.0/255, blue: 235.0/255, alpha: 1) // #EBEBEB
    static let brightBlue = UIColor(red: 0, green: 118.0/255, blue: 255.0/255, alpha: 1) // #0076FF
    static let tawn = UIColor(red: 233.0/255, green: 182.0/255, blue: 45.0/255, alpha: 1) //#E9b62d
    static let lightGrey = UIColor(red: 168.0/255, green: 168.0/255, blue: 168.0/255, alpha: 1) // #A8a8a8
    static let charcoal = UIColor(red: 96.0/255, green: 96.0/255, blue: 96.0/255, alpha: 1) // #606060
    static let blue = UIColor(red: 63.0/255, green: 146.0/255, blue: 243.0/255, alpha: 1) // #3f92f3
    
    // Drop shadow
    static let shadowColor = UIColor.blackColor().CGColor
    static let shadowOpacity:Float = 0.25
    static let shadowRadius:CGFloat = 1.2
    static let shadowOffset = CGSize(width: 0.0, height: 3.0)
    
    
    // -----------------------------------
    // Main Card view styling
    static let card_height:CGFloat = 204 // Height of each card
    static let card_imageHeight:CGFloat = 132 // Height of image in a card
    static let card_textMargin: CGFloat = 12 // Space between text, image, and card edges within card
    static let card_textHeight: CGFloat = 50 // Height of text
    static let card_topBackdropHeight: CGFloat = 36 // Height of that semitransparent gold part at the top
    static let card_topBackdropAlpha: CGFloat = 0.85 // Transparency of the semitransparent gold part at the top
    static let card_rightSectionWidth: CGFloat = 90 // Width of the small text section on the right
    
    // -----------------------------------
    // Card list styling
    static let cardlist_margin:CGFloat = 12 // Space between cards in a list
    static let cardlist_padding:CGFloat = 12 // Padding between the cards and its parent uiview container
    
    // -----------------------------------
    // Step Card styling
    static let stepCard_topLeftMargin:CGFloat = 25 // Distance of top of step card to top of screen, and the left margins when centered
    static let stepCard_bottomMargin:CGFloat = 14 // Distance of bottom of step card to bottom of screen
    static let stepCard_peekWidth:CGFloat = 15 // The amount the card is "teased" when it hangs off to the side of the screen
    
    // -----------------------------------
    // Some useful regions to test notifications
    static let wesBancoRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 40.4541175,longitude: -79.9462548), radius: notificationDelimiterRadius, identifier: "WesBanco")
    static let ajayansHomeRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 40.4535864,longitude: -79.9461685), radius: notificationDelimiterRadius, identifier: "Home")
    static let mhciLabRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 40.4495946,longitude: -79.9509742), radius: notificationDelimiterRadius, identifier: "MHCILab")
    
}