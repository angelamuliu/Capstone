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
    @IBOutlet weak var button: UIButton!
    
    var data: MiniCardable?

    func useData(data:MiniCardable) {
        self.data = data

        titleLabel.text = data.minicardTitle
        categoryImageView.image = data.categoryImage
        categoryLabel.text = data.category
        
        
        if data is Place {
            button.addTarget(self, action: "goToPlace:", forControlEvents: UIControlEvents.TouchUpInside)
        } else if data is Guide {
            button.addTarget(self, action: "goToGuide:", forControlEvents: UIControlEvents.TouchUpInside)
        }
    }
    
    // This is called when initializing from the xib and required
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func goToPlace(sender:UIButton!) {
        let place = data as? Place
        let placeVC = self.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("PlaceVC") as! PlaceVC
        placeVC.place = place
        
        self.window?.rootViewController?.navigationController?.pushViewController(placeVC, animated: true)
    }
    
    func goToGuide(sender:UIButton!) {
        let guide = data as? Guide
        let guideVC = self.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("GuideVC") as! GuideVC
        guideVC.guide = guide
        self.window?.rootViewController?.presentViewController(guideVC, animated: true, completion: nil)
    }
    
}
