//
//  StepCardAuthorView.swift
//  Capstone
//
//  Created by Angela Liu on 7/22/16.
//  Copyright © 2016 amliu. All rights reserved.
//

import Foundation
import UIKit

// The last page in a guide is about the author and gives credit
// Right now we just repurpose the data that can be contained inside of a page data object
class StepCardAuthorView : UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var writtenByLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var closeGuideButton: UIButton!
    @IBOutlet weak var thumbsUpButton: UIButton!
    @IBOutlet weak var thumbsDownButton: UIButton!
    
    var page: Page? // The displayed step/page
    var guideVC: GuideVC? // Hooked up guide view controller for dismiss
    
    func useData(page:Page, guideVC: GuideVC) {
        self.page = page
        imageView.image = UIImage(named: page.image_url)
        writtenByLabel.text = page.title
        descriptionLabel.text = page.description
        self.guideVC = guideVC
        
        thumbsUpButton.addTarget(self, action: "thumbsUp:", forControlEvents: UIControlEvents.TouchUpInside)
        thumbsDownButton.addTarget(self, action: "thumbsDown:", forControlEvents: UIControlEvents.TouchUpInside)
        closeGuideButton.addTarget(self, action: "dismiss:", forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    func dismiss(sender: UIButton!) {
        guideVC?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func thumbsUp(sender: UIButton!) {
        thumbsDownButton.alpha = 0.3
        thumbsUpButton.alpha = 1.0
    }
    
    func thumbsDown(sender: UIButton!) {
        thumbsDownButton.alpha = 1.0
        thumbsUpButton.alpha = 0.3
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}