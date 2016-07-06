//
//  HomeVC.swift
//  Capstone
//
//  Created by Angela Liu on 6/23/16.
//  Copyright © 2016 amliu. All rights reserved.
//

import UIKit
import CoreLocation

class HomeVC: UIViewController {
    
    // UI Elements
    @IBOutlet weak var loadingLabel: UILabel!
    
    // Other variables/states, places and guides, etc
    var showingGuides = true
    var placesManager:PlacesManager = PlacesManager.init(places: [])
    var placeCardList:CardViewList?
    var guideCardList:CardViewList?
    
    override func viewWillAppear(animated: Bool) {
        loadCardList()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // TODO: Customize "radius" for searching for locations lmao
    func loadCardList() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let userLocation = appDelegate.lastLocation {
            
            guard let db = try? SQLiteDatabase.open() else { return }
            placesManager.places = db.getPlaces("13:00", longitude: Float(userLocation.coordinate.longitude), latitude: Float(userLocation.coordinate.latitude), radius: 2000)
            let guides = db.getGuidesForPlace(placesManager.places.first!)
            db.close()
            
            placesManager.sortPlaces(userLocation)
            
            var guideCards = Set<CardView>()
            for guide in guides {
                guide.places = placesManager.places
                guideCards.insert(GuideCardView(guide: guide))
            }
            
            placeCardList = CardViewList(topleftPoint: CGPoint(x:10,y: 120), parentview: super.view, placesManager: placesManager)
            placeCardList?.redraw()
            placeCardList?.hidden = true
            
            guideCardList = CardViewList(topleftPoint: CGPoint(x:10,y: 120), parentview: super.view, cards: Array(guideCards))
            guideCardList?.redraw()

        } else { // Check if location has loaded a little later...
            NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "loadCardList", userInfo: nil, repeats: false)
        }
    }
    

    // Hides all UIViews that relate to waiting for a location, "loading"
    func hideLoading() {
        loadingLabel.hidden = true
    }
    
    @IBAction func toggleMode() {
        showingGuides = !showingGuides
        if showingGuides {
            guideCardList?.hidden = false
            placeCardList?.hidden = true
        } else {
            guideCardList?.hidden = true
            placeCardList?.hidden = false
        }
    }
    
    
}
