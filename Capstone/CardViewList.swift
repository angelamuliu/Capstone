//
//  CardViewList.swift
//  UIViews
//
//  Created by Angela Liu on 6/28/16.
//  Copyright © 2016 amliu. All rights reserved.
//

import Foundation
import UIKit

/**
 Given an array of cards, shows them in a stacked list. ALWAYS has a parent view, attach it to something else!
 Dynamically will adjust its frame size to fit the amount of cards that are inside of it
*/
class CardViewList : UIView {
    
    var cards:[CardView]
    
    // Returns the total height of all the card elements plus padding, used in its parent scroll view to calculate scroll
    var contentHeight : CGFloat {
        get {
            return (Constants.cardlist_padding * 2) + CGFloat(self.cards.count) * (Constants.card_height + Constants.cardlist_margin)
        }
    }
    
    /**
     Used for places
     Initializes with a placesmanager and loads the places inside as cards
    */
    init(topleftPoint: CGPoint, parentview: UIView, placesManager: PlacesManager, navigationController:UINavigationController?) {
        self.cards = [CardView]()
        super.init(frame: CGRect(origin: topleftPoint, size: CGSize(width: parentview.bounds.width - (2 * topleftPoint.x), height: 0)))
        self.loadPlaces(placesManager, navigationController: navigationController)
        parentview.addSubview(self)
    }
    
    /**
     Used for guides
     Given a top left point to start "drawing" on, a parent UIView (superview), and the cards to present,
     creates the card list that fits inside of the parent UIView
     */
    init(topleftPoint: CGPoint, parentview: UIView, cards:[CardView]) {
        self.cards = cards
        super.init(frame: CGRect(origin: topleftPoint, size: CGSize(width: parentview.bounds.width - (2 * topleftPoint.x), height: 0)))
        
        // Add in cards into view
        self.cards.forEach { (card) -> () in self.addSubview(card) }
        parentview.addSubview(self)
    }
    
    /**
     Redos all the calculations and stuff to replace content, size of frame
    */
    func redraw() {
        self.frame.size = CGSize(width: self.frame.width, height: CGFloat(self.cards.count) * (Constants.card_height + Constants.cardlist_margin))

        self.subviews.forEach { (subview) -> () in subview.removeFromSuperview() }
        var card:CardView
        for (var i = 0; i < self.cards.count; i += 1) {
            card = self.cards[i]
            card.frame = CGRect(x: 0, y: CGFloat(i) * (Constants.card_height + Constants.cardlist_margin), width: self.bounds.width, height: Constants.card_height)
            
            self.addSubview(card)
            card.redraw()
        }
    }
    
    /**
     Loads in places in a PlacesManager and adds them as cards to display
    */
    func loadPlaces(placesManager: PlacesManager, navigationController:UINavigationController?) {
        var cardView:PlaceCardView?
        for place in placesManager.places {
            cardView = PlaceCardView(place: place, navigationController: navigationController)
            self.cards.append(cardView!)
            self.addSubview(cardView!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
