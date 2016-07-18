//
//  PlaceCardView.swift
//  Capstone
//
//  Created by Angela Liu on 7/5/16.
//  Copyright © 2016 amliu. All rights reserved.
//

import Foundation
import UIKit

class PlaceCardView : CardView {
    
    var place:Place
    
    init(place:Place) {
        self.place = place
        super.init()
        
        // Setting text in the top gold part
        self.topLabel.text = "??? meters away <wip>"
        
        // TODO - replace with image_url of place
        self.image = UIImage(named: "ramen")
        self.imageView.image = self.image
        
        // TODO: Replace with something that chooses image based on category
        self.categoryIcon = UIImage.init(named:"category-present-icon")
        self.categoryIconView.image = self.categoryIcon
        self.categoryLabel.text = "Category"
        
        // TODO: Replace with actual values
        self.numLocationsLabel.text = "000"
        self.locationLabel.text = "Guides"
        
        self.nameLabel.text = "Really really really really really really really really really really long"
//        self.nameLabel.text = place.name
    }
    
    func buttonPressed(sender: UIButton!) {
        let placeVC = self.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("PlaceVC") as! PlaceVC
        placeVC.place = self.place
        
        self.window?.rootViewController?.presentViewController(placeVC, animated: true, completion: nil) // NOTE: This is modal. Would need to find a way to push onto stack for places
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
