//
//  Page.swift
//  Capstone
//
//  Created by Angela Liu on 7/3/16.
//  Copyright © 2016 amliu. All rights reserved.
//

import Foundation

class Page {
    
    var id: Int // SQL Id, unique
    var title: String
    var description: String
    var image_url: String
    
    var guide: Guide?
    
    init(id: Int, title:String, description:String?, image_url:String?) {
        self.id = id
        self.title = title
        self.description = description != nil ? description! : Constants.defaultDescription
        self.image_url = image_url != nil ? image_url! : Constants.defaultUrl
    }
    
}
