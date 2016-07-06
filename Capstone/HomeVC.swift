//
//  HomeVC.swift
//  Capstone
//
//  Created by Angela Liu on 6/23/16.
//  Copyright © 2016 amliu. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let db = try? SQLiteDatabase.open() else { return }
        let places = db.getPlaces("13:00", longitude: 100, latitude: 900, radius: 100)
        let guides = db.getGuidesForPlace(places.first!)
        db.close()
        
//        let placeManager = PlacesManager.init(places: places)
//        placeManager.sortPlaces(<#T##userLocation: CLLocation##CLLocation#>)
        
        var placeCards = [CardView]()
        for place in places {
            placeCards.append(PlaceCardView(place: place))
        }
        var guideCards = Set<CardView>()
        for guide in guides {
            guide.places = places
            guideCards.insert(GuideCardView(guide: guide))
        }
        
        let placeCardList = CardViewList(topleftPoint: CGPoint(x:10,y: 80), parentview: super.view, cards: placeCards)
        placeCardList.redraw()
        
        let guideCardList = CardViewList(topleftPoint: CGPoint(x:10,y: 80), parentview: super.view, cards: Array(guideCards))
        guideCardList.redraw()
    }
    
}
