//
//  SearchResultCardView.swift
//  Capstone
//
//  Created by Angela Liu on 7/19/16.
//  Copyright © 2016 amliu. All rights reserved.
//

import Foundation
import UIKit

class SearchResultCardView : UIView {
    
    // UI Elements
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var data: MiniCardable?

    func useData(data:MiniCardable) {
        self.data = data

        titleLabel.text = data.minicardTitle
        categoryImageView.image = data.categoryImage
        categoryLabel.text = data.category
    }
    
    // This is called when initializing from the xib and required
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
