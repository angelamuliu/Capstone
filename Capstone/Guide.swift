//
//  Guide.swift
//  Capstone
//
//  Created by Angela Liu on 7/3/16.
//  Copyright © 2016 amliu. All rights reserved.
//

import Foundation
import UIKit

class Guide : MiniCardable {
    
    var id : Int // SQL ID, unique
    var title: String
    var category: String
    var subcategory: String
    var hidden: Bool
    var image_url: String
    var description: String
    var tags:[String]
    var pages: [Page]
    
    var placesManager = PlacesManager.init(places: []) // Connected places, ordered by relevance (location, time, etc)
    
    init(id: Int, title:String, category:String, subcategory:String?, hidden: Bool?, image_url:String?, description:String?, tags:String?) {
        self.id = id
        self.title = title
        self.category = category
        self.subcategory = subcategory != nil ? subcategory! : Constants.defaultSubCategory
        self.hidden = hidden != nil ? hidden! : true
        self.image_url = image_url != nil ? image_url! : Constants.defaultUrl
        self.description = description != nil ? description! : Constants.defaultDescription
        self.tags = tags!.componentsSeparatedByString(",")
        self.pages = []
    }
    
    var places : [Place] {
        get {
            if placesManager.places.isEmpty {
                guard let db = try? SQLiteDatabase.open() else
                {
                    print("Database did not load. Using failsafe hardcoded values for now.")
                    return []
                }
                placesManager.places = db.getPlacesForGuide(self)
                db.close()
            }
            return placesManager.places
        }
    }
    
    // Mini card protocol methods
    var minicardTitle : String {
        get { return title }
    }
    var cardImage : UIImage? {
        get { return (UIImage(named: self.image_url))! }
    }
    var categoryImage : UIImage? { // TODO: Make this not default to a present icon
        get { return UIImage(named: "category-present-icon")! }
    }
    var additionalText : String? {
        get { return nil }
    }
    
    
}