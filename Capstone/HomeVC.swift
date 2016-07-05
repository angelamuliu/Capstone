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
        
        var cards = [CardView]()
        for place in places {
            cards.append(PlaceCardView(place: place))
        }
        for guide in guides {
            guide.places = places
            cards.append(GuideCardView(guide: guide))
        }
        let cardList = CardViewList(topleftPoint: CGPoint(x:10,y: 80), parentview: super.view, cards: cards)
        cardList.redraw()
    }
    
}
