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
    @IBOutlet weak var spotToggle: UIButton!
    @IBOutlet weak var guideToggle: UIButton!
    
    // Other variables/states, places and guides, etc
    var showingGuides = true
    var placeCardList:CardViewList?
    var guideCardList:CardViewList?
    
    var guideCardIds = [Int]() // Array of guide IDs displayed, without duplication
    var guides = [Int: Guide]() // Hash that we use with guideCardIds to get guides
    var guideCards = [GuideCardView]()
    
    var cardScrollContainer:UIScrollView? // Scroll view that holds the card lists
    
    // Since CardViewLists are dependant on bounds, which are determined in viewDidLayoutSubview, initialization of it is placed there. But to prevent random visual shit or unnecessary loading, we check if they've already been added first
    var cardsLoaded:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !cardsLoaded {
            loadCardList()
            cardsLoaded = true
        }

    }
    
    // TODO: Customize "radius" for searching for locations lmao, remove placeholder time
    func loadCardList() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // Could use some refactoring
        for place in appDelegate.placesManager.places {
            for guide in place.guides! { // Already inserted, but update the guide to have the place
                if guideCardIds.contains(guide.id) {
                    guides[guide.id]?.placesManager.places.append(place)
                } else { // New guide
                    guideCardIds.append(guide.id)
                    guide.placesManager.places.append(place)
                    guides[guide.id] = guide
                    guideCards.append(GuideCardView.init(guide: guide))
                }
            }
        }
        
        cardScrollContainer = super.view.subviews.filter({$0 is UIScrollView})[0] as? UIScrollView
        
        placeCardList = CardViewList(topleftPoint: CGPoint(x:Constants.cardlist_padding,y: Constants.cardlist_padding), parentview: cardScrollContainer!, placesManager: appDelegate.placesManager)
        placeCardList?.redraw()
        placeCardList?.hidden = true
        
        guideCardList = CardViewList(topleftPoint: CGPoint(x:Constants.cardlist_padding,y: Constants.cardlist_padding), parentview: cardScrollContainer!, cards: guideCards)
        guideCardList?.redraw()
        
        // Let the scrollview know which its presenting and set its scroll height to it
        cardScrollContainer!.contentSize = CGSize(width: super.view.bounds.width, height: (guideCardList?.contentHeight)!)
        
        hideLoading()
    }
    
    
    // Hides all UIViews that relate to waiting for a location, "loading"
    func hideLoading() {
        loadingLabel.hidden = true
    }
    
    @IBAction func toggleSpots() {
        showingGuides = false
        
        guideCardList!.hidden = true
        guideToggle.setTitleColor(Constants.grey, forState: UIControlState.Normal)
        guideToggle.titleLabel?.font = UIFont(name: "Lato-Regular", size: 14)
        
        placeCardList!.hidden = false
        spotToggle.setTitleColor(Constants.blue, forState: UIControlState.Normal)
        spotToggle.titleLabel?.font = UIFont(name: "Lato-Bold", size: 14)
//
//        let scrollView = super.view.subviews.filter({$0 is UIScrollView})[0] as! UIScrollView
        cardScrollContainer!.contentSize = CGSize(width: super.view.bounds.width, height: (placeCardList?.contentHeight)!)
//        scrollView.setNeedsDisplay()
    }
    
    @IBAction func toggleGuides() {
        showingGuides = true

        guideCardList!.hidden = false
        guideToggle.setTitleColor(Constants.blue, forState: UIControlState.Normal)
        guideToggle.titleLabel?.font = UIFont(name: "Lato-Bold", size: 14)
        
        placeCardList!.hidden = true
        spotToggle.setTitleColor(Constants.grey, forState: UIControlState.Normal)
        spotToggle.titleLabel?.font = UIFont(name: "Lato-Regular", size: 14)
        
//        let scrollView = super.view.subviews.filter({$0 is UIScrollView})[0] as! UIScrollView
        cardScrollContainer!.contentSize = CGSize(width: super.view.bounds.width, height: (guideCardList?.contentHeight)!)
//        scrollView.setNeedsDisplay()
    }
    
    
    
    
    
}
