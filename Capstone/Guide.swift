//
//  Guide.swift
//  Capstone
//
//  Created by Angela Liu on 7/3/16.
//  Copyright © 2016 amliu. All rights reserved.
//

import Foundation

class Guide {
    
    private static let defaultTitle = "none"
    private static let defaultCategory = "none"
    private static let defaultSubCategory = "none"
    private static let defaultImageUrl = "none"
    
    var id : Int // SQL ID, unique
    var title: String
    var category: String
    var subcategory: String
    var hidden: Bool
    var image_url: String
    var pages: [Page]
    
    init(id: Int, title:String?, category:String?, subcategory:String?, hidden: Bool?, image_url:String?) {
        self.id = id
        self.title = title != nil ? title! : Guide.defaultTitle
        self.category = category != nil ? category! : Guide.defaultCategory
        self.subcategory = subcategory != nil ? subcategory! : Guide.defaultSubCategory
        self.hidden = hidden != nil ? hidden! : true
        self.image_url = image_url != nil ? image_url! : Guide.defaultImageUrl
        self.pages = []
    }
    
    
    
}