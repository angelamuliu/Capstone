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
    
    // UI Elements
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!

    @IBAction func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalTransitionStyle = .FlipHorizontal
        
        if let loadedPlace = place {
            imageView.image = UIImage(named: loadedPlace.image_url!)
            imageView.clipsToBounds = true
            imageView.contentMode = .ScaleAspectFill
            
            nameLabel.text = loadedPlace.name
            statusLabel.text = loadedPlace.getIsPlaceOpen() ? "Open" : "Closed"
            categoryLabel.text = loadedPlace.category
            addressLabel.text = loadedPlace.address
            phoneLabel.text = loadedPlace.phone
            hourLabel.text = loadedPlace.hours
        }
    }
    
}
