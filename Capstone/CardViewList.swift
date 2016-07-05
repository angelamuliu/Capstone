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
    
    static let cardMargin:CGFloat = 10 // Space between cards in the list
    
    var cards: [CardView]
    
    /**
     Given a top left point to start "drawing" on, a parent UIView (superview), and the cards to present,
     creates the card list that fits inside of the parent UIView
     */
    init(topleftPoint: CGPoint, parentview: UIView, cards:[CardView]) {
        self.cards = cards
        super.init(frame: CGRect(origin: topleftPoint, size: CGSize(width: parentview.bounds.width - (2 * topleftPoint.x), height: 0)))
        
        // Add in cards into view
        self.cards.forEach { (card) -> () in self.addSubview(card) }
        parentview.addSubview(self)
        
        // For debugging...
//        self.backgroundColor = UIColor.redColor()
    }
    
    /**
     Redos all the calculations and stuff to replace content, size of frame
    */
    func redraw() {
        self.frame.size = CGSize(width: self.frame.width, height: CGFloat(self.cards.count) * (CardView.height + CardViewList.cardMargin))

        self.subviews.forEach { (subview) -> () in subview.removeFromSuperview() }
        var card:CardView
        for (var i = 0; i < self.cards.count; i++) {
            card = self.cards[i]
            card.frame = CGRect(x: 0, y: CGFloat(i) * (CardView.height + CardViewList.cardMargin), width: self.bounds.width, height: CardView.height)
            
            self.addSubview(card)
            card.redraw()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
