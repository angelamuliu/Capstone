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
    var navigationController:UINavigationController?
    
    init(place:Place, navigationController: UINavigationController?) {
        self.place = place
        super.init()
        
        // Setting text in the top gold part
        self.topLabel.text = place.distance != nil ? "\(Int(place.distance!)) meters away" : "Location disabled"
        
        self.image = UIImage(named: place.image_url!)
        self.imageView.image = self.image
        
        // TODO: Replace with something that chooses image based on category
        self.categoryIcon = UIImage.init(named:"category-present-icon")
        self.categoryIconView.image = self.categoryIcon
        self.categoryLabel.text = place.category
        
        self.numLocationsLabel.text = "\(place.guides.count)"
        self.locationLabel.text = "Guides"
        
        self.nameLabel.text = place.name
        
        // We need the navigation controller in order to do push
        self.navigationController = navigationController
    }
    
    func buttonPressed(sender: UIButton!) {
        let placeVC = self.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("PlaceVC") as! PlaceVC
        placeVC.place = self.place
        
        if navigationController != nil { // Use push
            navigationController?.pushViewController(placeVC, animated: true)
        } else { // No navigation controller set for some reason. Use modal
            self.window?.rootViewController?.presentViewController(placeVC, animated: true, completion: nil)
        }
        
    }
    
    // Called to update the UI card's distance labels
    func refreshLocation() {
        dispatch_async(dispatch_get_main_queue(), {
            self.topLabel.text = self.place.distance != nil ? "\(Int(self.place.distance!)) meters away" : "Location disabled"
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
