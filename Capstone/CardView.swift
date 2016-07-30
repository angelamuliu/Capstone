//
//  CardView.swift
//  UIViews
//
//  Created by Angela Liu on 6/28/16.
//  Copyright © 2016 amliu. All rights reserved.
//

// Note: .setNeedsDisplay() may be used to "redraw" UI in the future ... but so far haven't needed it
// http://stackoverflow.com/questions/1503761/what-is-the-most-robust-way-to-force-a-uiview-to-redraw

import Foundation
import UIKit


/**
 Handles initializing and redrawing the cardview, and all the stuff that has to be done with UIViews
*/
class CardView : UIView {
    
    var image:UIImage?
    var imageView:UIImageView
    
    var topBackdrop: UIView
    var topLabel:UILabel
    
    var nameLabel:UILabel
    
    var categoryIcon:UIImage?
    var categoryIconView: UIImageView
    var categoryLabel:UILabel
    
    var numLocationsLabel: UILabel
    static let locationIconImage:UIImage? = UIImage.init(named: "location-icon-small")
    var locationIconView: UIImageView
    var locationLabel: UILabel
    
    var button:UIButton
    
    /**
     Simply creates a card. Note that it initializes with a placeholder content, width and position, since that is handled
     by the CardViewList class which houses cards and the subclasses for content
    */
    init() {
        // Top part setup - The BG Color
        self.topBackdrop = UIView.init(frame: CGRect(x: 0, y: 0, width: 100, height: Constants.card_topBackdropHeight))
        self.topBackdrop.backgroundColor = Constants.tawn
        self.topBackdrop.alpha = Constants.card_topBackdropAlpha
        
        // Top part setup - The text
        self.topLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 100, height: Constants.card_textHeight))
        self.topLabel.text = ""
        self.topLabel.font = UIFont(name: "Lato-Regular", size: 14)
        self.topLabel.textColor = UIColor.whiteColor()
        self.topLabel.numberOfLines = 0
        
        // ImageView Setup - Uses a placeholder for now
        self.imageView = UIImageView.init(frame: CGRect(x: 0, y:0, width: 100, height: Constants.card_imageHeight))
        self.imageView.contentMode = .ScaleAspectFill
        self.imageView.clipsToBounds = true
        
        // Title text loading
        self.nameLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 100, height: Constants.card_textHeight))
        self.nameLabel.text = ""
        self.nameLabel.font = UIFont(name: "Lato-Regular", size: 14)
//        self.nameLabel.lin
        
        // Category subsection - icon
        self.categoryIconView = UIImageView.init(frame: CGRect(x: 0, y:0, width: 14, height: 14))
        self.categoryIconView.contentMode = .ScaleAspectFill
        self.categoryIconView.clipsToBounds = true
        
        // Category label text
        self.categoryLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.categoryLabel.text = ""
        self.categoryLabel.font = UIFont(name: "Lato-Regular", size: 14)
        self.categoryLabel.textColor = Constants.charcoal
        
        // Location subsection
        self.numLocationsLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.numLocationsLabel.textAlignment = .Right
        self.numLocationsLabel.font = UIFont(name: "Lato-Regular", size: 14)
        self.numLocationsLabel.textColor = Constants.charcoal
        
        self.locationIconView = UIImageView.init(frame: CGRect(x: 0, y:0, width: 7, height: 12))
        self.locationIconView.contentMode = .ScaleAspectFill
        self.locationIconView.clipsToBounds = true
        self.locationIconView.image = CardView.locationIconImage
        
        self.locationLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.locationLabel.textAlignment = .Center
        self.locationLabel.font = UIFont(name: "Lato-Regular", size: 10)
        self.locationLabel.textColor = Constants.charcoal
        
        // Button setup - invisible that overlays the entire card
        self.button = UIButton.init(frame: CGRect(x: 0, y: 0, width: 100, height: 10))
        self.button.backgroundColor = UIColor.clearColor()
        
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: Constants.card_height))
        
        // Styling the card backdrop
        self.backgroundColor = UIColor.whiteColor()
        self.layer.shadowColor = Constants.shadowColor
        self.layer.shadowOffset = Constants.shadowOffset
        self.layer.shadowOpacity = Constants.shadowOpacity
        self.layer.shadowRadius = Constants.shadowRadius
        
        
        // Connecting the button to an action in the CardView class
        self.button.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
        
        
        // Adding subviews to this cardview in order of rendering
        self.addSubview(self.imageView)
        self.addSubview(self.nameLabel)
        
        self.addSubview(self.categoryIconView)
        self.addSubview(self.categoryLabel)
        
        self.addSubview(self.numLocationsLabel)
        self.addSubview(self.locationIconView)
        self.addSubview(self.locationLabel)
        
        self.addSubview(self.topBackdrop)
        self.addSubview(self.topLabel)
        
        self.addSubview(self.button)
    }
    
    /**
     If the parent frame updated, or if the card itself updated (in terms of position, or size),
     we have to redraw the frame to fit its own subviews
    */
    func redraw() {
        if let parentview = self.superview {
            self.imageView.frame = CGRect(x: 0, y: 0, width: parentview.bounds.width, height: Constants.card_imageHeight)
            
            self.nameLabel.frame = CGRect(x: Constants.card_textMargin, y: Constants.card_imageHeight + 14, width: parentview.bounds.width - (2 * Constants.card_textMargin) - Constants.card_rightSectionWidth, height: 22)
            
            self.topBackdrop.frame = CGRect(x: 0, y: 0, width: parentview.bounds.width, height: Constants.card_topBackdropHeight)
            self.topLabel.frame = CGRect(x: Constants.card_textMargin, y: 9, width: parentview.bounds.width, height: 0)
            self.topLabel.sizeToFit() // fits the frame to what's needed, and top aligns
            
            self.categoryIconView.frame = CGRect(x: Constants.card_textMargin, y: Constants.card_imageHeight + 42, width: 14, height: 14)
            self.categoryLabel.frame = CGRect(x: 32, y: Constants.card_imageHeight + 40, width: parentview.bounds.width, height: 0)
            self.categoryLabel.sizeToFit()
            
            self.numLocationsLabel.frame = CGRect(x: parentview.bounds.width-38-30, y: Constants.card_imageHeight + 18, width: 30, height: 22)
            self.locationIconView.frame = CGRect(x: parentview.bounds.width-25-7, y: Constants.card_imageHeight + 22, width: 10, height: 14)
            self.locationLabel.frame = CGRect(x: parentview.bounds.width - Constants.card_rightSectionWidth, y: Constants.card_imageHeight + 32, width: Constants.card_rightSectionWidth, height: 22)
            
            // Clear button over all elements that brings you to necessary page
            self.button.frame = CGRect(x: 0, y: 0, width: parentview.bounds.width, height: self.bounds.height)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        // NSCoder allows something to be quickly deserialized into data and archived into a network
        // ...which isn't necessary for this UIView since it gets changed all the time anyway
        fatalError("init(coder:) has not been implemented")
    }

}









