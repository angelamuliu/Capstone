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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var contentStackView: UIStackView! // Stack that has a card as the 1st element, and the minicards are shoved on
    
    @IBAction func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Present the place's information
        if let loadedPlace = place {
            imageView.image = UIImage(named: loadedPlace.image_url!)
            
            // TODO: Make category icon load from place
            
            nameLabel.text = loadedPlace.name
            statusLabel.text = loadedPlace.getIsPlaceOpen() ? "Open" : "Closed"
            categoryLabel.text = loadedPlace.category
            addressLabel.text = loadedPlace.address
            hourLabel.text = loadedPlace.hours
            distanceLabel.text = "\(Int(loadedPlace.distance!)) meters"
        }
        
        // Present its guides if it has any
        for guide in (place?.guides)! {
            if let miniCard = NSBundle.mainBundle().loadNibNamed("MiniCardView", owner: self, options: nil).first as? MiniCardView {
                miniCard.useData(guide)
                contentStackView.addArrangedSubview(miniCard)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "spotToMap" {
            let mapVC = segue.destinationViewController as! MapVC
            mapVC.place = self.place
        }
    }

}
