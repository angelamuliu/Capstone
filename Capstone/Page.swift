//
//  Page.swift
//  Capstone
//
//  Created by Angela Liu on 7/3/16.
//  Copyright © 2016 amliu. All rights reserved.
//

import Foundation

class Page {
    
    static private let defaultTitle = "none"
    static private let defaultDescription = "none"
    static private let defaultImageUrl = "none"
    
    var id: Int // SQL Id, unique
    var title: String
    var description: String
    var image_url: String
    
    init(id: Int, title:String?, description:String?, image_url:String?) {
        self.id = id
        self.title = title != nil ? title! : Page.defaultTitle
        self.description = description != nil ? description! : Page.defaultDescription
        self.image_url = image_url != nil ? image_url! : Page.defaultImageUrl
    }
    
}
