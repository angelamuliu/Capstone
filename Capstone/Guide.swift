//
//  Guide.swift
//  Capstone
//
//  Created by Angela Liu on 7/3/16.
//  Copyright © 2016 amliu. All rights reserved.
//

import Foundation

class Guide {
    
    var id : Int // SQL ID, unique
    var title: String
    var category: String
    var subcategory: String
    var hidden: Bool
    var image_url: String
    var pages: [Page]
    
    init(id: Int, title:String?, category:String?, subcategory:String?, hidden: Bool?, image_url:String?) {
        self.id = id
        self.title = title != nil ? title! : Constants.defaultTitle
        self.category = category != nil ? category! : Constants.defaultCategory
        self.subcategory = subcategory != nil ? subcategory! : Constants.defaultSubCategory
        self.hidden = hidden != nil ? hidden! : true
        self.image_url = image_url != nil ? image_url! : Constants.defaultUrl
        self.pages = []
    }
    
    
    
}