//
//  User.swift
//  UIViews
//
//  Created by Angela Liu on 7/1/16.
//  Copyright © 2016 amliu. All rights reserved.
//

import Foundation

/**
 Used to access the settings the user has set or that we know e.g. "Knows Japanese"
*/
struct User {
    
    // User variables, and the defaults. Add more as necessary, but write setters please
    static var name: String? = ""
    static var knowsJapanese: Bool? = false
    
    // Used to access the saved information
    static let savedSettings = NSUserDefaults.standardUserDefaults()

    /**
     Loads persistant saved settings in initializes the variables for User.
     Called in AppDelegate on boot, allows User to be accessible anywhere
    */
    static func loadUser() {
        self.name = savedSettings.stringForKey("name")
        self.knowsJapanese = savedSettings.boolForKey("knowsJapanese")
    }
    
    // GETTERS: Just do like User.name, User.knowsJapanese
    
    // SETTERS
    static func setName(name:String) {
        self.name = name
        User.savedSettings.setValue(name, forKey: "name")
    }
    
    static func setKnowsJapanese(knowsJapanese:Bool) {
        self.knowsJapanese = knowsJapanese
        User.savedSettings.setValue(knowsJapanese, forKey: "knowsJapanese")
    }
    
}