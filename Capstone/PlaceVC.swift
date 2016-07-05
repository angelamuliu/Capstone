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

    @IBAction func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalTransitionStyle = .FlipHorizontal
    }
    
}
