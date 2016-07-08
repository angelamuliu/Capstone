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
        
        // TODO - replace with image_url of place
        self.image = UIImage(named: "ramen")
        self.imageView.image = self.image
        
        self.nameLabel.text = place.name
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
