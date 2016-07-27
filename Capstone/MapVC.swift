//
//  MapVC.swift
//  Capstone
//
//  Created by Angela Liu on 7/21/16.
//  Copyright © 2016 amliu. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapVC : UIViewController {
    
    var place: Place?
    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 500
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if place != nil {
            centerMapOnLocation((place?.location)!)
            
            let pin = MKPointAnnotation()
            pin.title = place?.name
            pin.coordinate = (place?.location.coordinate)!
            mapView.addAnnotation(pin)
            
            mapView.showsUserLocation = true
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
}