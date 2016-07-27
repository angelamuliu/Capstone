//
//  MiniCardView.swift
//  Capstone
//
//  Created by Angela Liu on 7/18/16.
//  Copyright © 2016 amliu. All rights reserved.
//

import Foundation
import UIKit

/** 
 Connects to the MiniCardView.xib file, which has its size set to "freeform" to allow for differing containers
 Note: To allow the xib to stack, you really gotta go hard with the constraints. Like, put them all on.
 
 To initialize EX:
 
 if let miniCard = NSBundle.mainBundle().loadNibNamed("MiniCardView", owner: self, options: nil).first as? MiniCardView {
    miniCard.useData(guide)
    contentStackView.addArrangedSubview(miniCard)
 }
 
*/
class MiniCardView : UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var extraTextLabel: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    var data: MiniCardable? // The data presented - required
    
    // Since I couldn't find a good way to have the xib load with params passed in for initialization, use this to hook up
    // the data source
    func useData(data:MiniCardable) {
        self.data = data
        imageView.image = data.cardImage
        titleLabel.text = data.minicardTitle
        categoryImageView.image = data.categoryImage
        categoryLabel.text = data.category
        extraTextLabel.text = data.additionalText
        
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
        
        // To avoid weird like... recursive nav controllers and spagetti, we have to
        // 1. Get the home screen's view controller, which is the ROOT of all views
        // 2. Pop off the guide modal that is currently shown
        // 3. Now push on the place
        let viewControllers = self.window?.rootViewController?.childViewControllers.first
        self.window?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
        self.window?.rootViewController?.childViewControllers.first?.navigationController?.pushViewController(placeVC, animated: true)
    }
    
    func goToGuide(sender:UIButton!) {
        let guide = data as? Guide
        let guideVC = self.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("GuideVC") as! GuideVC
        guideVC.guide = guide
        self.window?.rootViewController?.presentViewController(guideVC, animated: true, completion: nil)
    }
    
    
}





