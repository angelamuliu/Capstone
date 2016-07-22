//
//  StepCardView.swift
//  Capstone
//
//  Created by Angela Liu on 7/20/16.
//  Copyright © 2016 amliu. All rights reserved.
//

import Foundation
import UIKit

class StepCardView : UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var guideLabel: UILabel!
    @IBOutlet weak var stepNumLabel: UILabel!
    
    var page: Page? // The displayed step/page
    
    func useData(page:Page) {
        self.page = page
        
        imageView.image = UIImage(named: page.image_url)
        nameLabel.text = page.title
        descLabel.text = page.description
        guideLabel.text = page.guide?.title
    }
    
    // Sets text at bottom: step what out of what
    func setBottomLabel(index:Int, totalSteps:Int) {
        stepNumLabel.text = "Step \(index) of \(totalSteps)"
    }
    
    @IBOutlet weak var stepLabel: UILabel!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}