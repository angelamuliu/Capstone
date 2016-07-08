//
//  GuideCardView.swift
//  Capstone
//
//  Created by Angela Liu on 7/5/16.
//  Copyright © 2016 amliu. All rights reserved.
//

import Foundation
import UIKit

class GuideCardView : CardView {
    
    var guide:Guide
    
    init(guide:Guide) {
        self.guide = guide
        super.init()
        
        // TODO: Replace with image_url of guide
        self.image = UIImage.init(named:"ramen")
        self.imageView.image = self.image
        
        // Sort locations first, then find the closest
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let lastLocation = appDelegate.lastLocation {
            guide.placesManager.sortPlaces(lastLocation)
            if let closestPlace = guide.places.first {
                self.nameLabel.text = guide.title + " at " + closestPlace.name
            } else {
                self.nameLabel.text = guide.title
            }
        } else { self.nameLabel.text = guide.title }
    }
    
    func buttonPressed(sender: UIButton!) {
        let guideVC = self.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("GuideVC") as! GuideVC
        guideVC.guide = self.guide
        
        self.window?.rootViewController?.presentViewController(guideVC, animated: true, completion: nil) // NOTE: This is modal. Would need to find a way to push onto stack for places
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}