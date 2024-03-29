//
//  AppDelegate.swift
//  Capstone
//
//  Created by Angela Liu on 6/23/16.
//  Copyright © 2016 amliu. All rights reserved.
//

import UIKit
import CoreLocation

struct NotificationStack
{
    var localNotification: UILocalNotification
    var region: CLRegion
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?
    var locationManager: CLLocationManager = CLLocationManager()
    var lastLocation: CLLocation?
    var placesManager:PlacesManager = PlacesManager.init(places: [])
    var triggeredLocalNotifications: [NotificationStack]?
    
    let center = NSNotificationCenter.defaultCenter() // Handles broadcasting custom notifications to other views
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        User.loadUser()
        setupLocationManager()
        setupDatabase()
        // registering app for notifications
        application.registerUserNotificationSettings(
            UIUserNotificationSettings(
                forTypes: [.Alert, .Badge, .Sound],
                categories: nil))
        
        Clarifai.refreshAccessToken()
        
        SQLiteDatabase.createOnDesktop()
        return true
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        setupNotifications(application)
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    /* creates/opens the database and caches the places into self.placesManager, so that subsequent requests do not require db calls. */
    func setupDatabase()
    {
        SQLiteDatabase.safeCreate()
        // setting MHCI Lab location as default, to allow further steps to continue
        if self.lastLocation == nil{
            self.lastLocation = Constants.defaultUserLocation
        }
        guard let db = try? SQLiteDatabase.open() else
        {
            print("Database did not load. Using failsafe hardcoded values for now.")
            /* if the database fails to populate (this is a random occurence, so it is good to have a failsafe hardcoded set of values for the demo*/
            placesManager.places = Utilities.getTempPlaces()
            placesManager.sortPlaces(self.lastLocation!)
            return
        }
        
        // if database sucessfully opens
        // Replace Constants.defaultCurrentTime with Utilities.getCurrentTime()
        placesManager.places = db.getPlaces(Constants.defaultCurrentTime, longitude: Float(self.lastLocation!.coordinate.longitude), latitude: Float(self.lastLocation!.coordinate.latitude), radius: Constants.radiusForPlacesToDisplay)
        for place in placesManager.places
        {
            place.guides = db.getGuidesForPlace(place)
        }
        
        db.close()
        placesManager.sortPlaces(self.lastLocation!)
    }
    
    func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization() // This one runs forever, even when app in bg
        locationManager.allowsBackgroundLocationUpdates = true;
        //locationManager.requestWhenInUseAuthorization()
        // this needs to be called after the authorization call
        locationManager.startUpdatingLocation()
    }
    
    func setupNotifications(application:UIApplication) {
        self.triggeredLocalNotifications = []
        // cancels all existing notifications
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        for place in self.placesManager.places
        {
            // TODO : Figure out how to know which guide at a place corresponds to a location
            if place.guides.count > 0
            {
                let alertMessage = place.guides.first!.title + " at " + place.name
                
                
                let region = CLCircularRegion(center: place.location.coordinate, radius:Constants.notificationDelimiterRadius, identifier: alertMessage)
                locationManager.startMonitoringForRegion(region)
                print(place.name + String(place.location.coordinate))
                // Changed below - we track any change, but only resort if order changed
                // User must move X meters before a new location event is fired
                locationManager.distanceFilter = kCLDistanceFilterNone // Only send location event when distance has changed by certain amount

            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.lastLocation = locations.last
        let wasFirst = self.placesManager.places.first
        self.placesManager.sortPlaces(self.lastLocation!)
        
        if wasFirst?.id != self.placesManager.places.first?.id { // Only send sort event if order has changed where closest thing is different
            center.postNotification(NSNotification(name: Constants.locationEvent_reorder, object: nil)) // send event to all VCs, home VC listens
        } else { // Location changed but order didn't - just update the distances
            center.postNotification(NSNotification(name: Constants.locationEvent_redraw, object: nil))
        }
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let notification = UILocalNotification()
        notification.alertBody = region.identifier
        notification.alertTitle = "Abeo"
        notification.soundName = "Default";
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        triggeredLocalNotifications?.append(NotificationStack(localNotification: notification, region: region))
    }
    
    // canceling existing notification when you get out of region, and deleting the notification from the stack
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        var indexToRemove:Int
        indexToRemove = -1
        for triggeredLocalNotification in triggeredLocalNotifications!
        {
            indexToRemove += 1
            if triggeredLocalNotification.region == region
            {
                UIApplication.sharedApplication().cancelLocalNotification(triggeredLocalNotification.localNotification)
                break
            }
        }
        if indexToRemove >= 0
        {
            triggeredLocalNotifications?.removeAtIndex(indexToRemove)
        }
    }
    
    func locationManager(manager: CLLocationManager,
                         didFailWithError error: NSError) {
    }
}

