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
    var placeCardList:CardViewList?
    var guideCardList:CardViewList?
    
    var guideCardIds = [Int]() // Array of guide IDs displayed, without duplication
    var guides = [Int: Guide]() // Hash that we use with guideCardIds to get guides
    var guideCards = [GuideCardView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        loadCardList() // Needs to be called here otherwise the width of some uiviews are not set yet
    }
    
    // TODO: Customize "radius" for searching for locations lmao, remove placeholder time
    func loadCardList() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        print(appDelegate.lastLocation)
        
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
        
        let scrollView = super.view.subviews.filter({$0 is UIScrollView})[0] as! UIScrollView
        
        placeCardList = CardViewList(topleftPoint: CGPoint(x:12,y: 120), parentview: scrollView, placesManager: appDelegate.placesManager)
        placeCardList?.redraw()
        placeCardList?.hidden = true
        
        guideCardList = CardViewList(topleftPoint: CGPoint(x:12,y: 120), parentview: scrollView, cards: guideCards)
        guideCardList?.redraw()
        
        // Let the scrollview know which its presenting and set its scroll height to it
        scrollView.contentSize = CGSize(width: super.view.bounds.width, height: (guideCardList?.contentHeight)!)
        
        hideLoading()
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
