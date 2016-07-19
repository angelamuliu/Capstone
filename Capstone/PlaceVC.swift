//
//  PlaceVC.swift
//  Capstone
//
//  Created by Angela Liu on 6/23/16.
//  Copyright © 2016 amliu. All rights reserved.
//

import UIKit

class PlaceVC: UIViewController {
    
    var place:Place?
    
//    // UI Elements
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!

    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let loadedPlace = place {
            imageView.image = UIImage(named: loadedPlace.image_url!)
            
            // TODO: Make category icon load from place
            // TODO: Make distance load
            
            nameLabel.text = loadedPlace.name
            statusLabel.text = loadedPlace.getIsPlaceOpen() ? "Open" : "Closed"
            categoryLabel.text = loadedPlace.category
            addressLabel.text = loadedPlace.address
            hourLabel.text = loadedPlace.hours
        }
    }
    
}
