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
    
    static let height:CGFloat = 200
    static let imageHeight:CGFloat = 100
    static let textMargin: CGFloat = 10
    static let textHeight: CGFloat = 50
    static let buttonWidth: CGFloat = 50
    
    var image: UIImage?
    var imageView:UIImageView
    
    var nameLabel: UILabel
    
    var button: UIButton
    
    /**
     Simply creates a card. Note that it initializes with a placeholder content, width and position, since that is handled
     by the CardViewList class which houses cards and the subclasses for content
    */
    init() {
        // ImageView Setup - Uses a placeholder for now
        self.imageView = UIImageView.init(frame: CGRect(x: 0, y:0, width: 100, height: CardView.imageHeight))
        self.imageView.contentMode = .ScaleAspectFill
        self.imageView.clipsToBounds = true;
        
        // Static text loading
        self.nameLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 100, height: CardView.textHeight))
        self.nameLabel.text = ""
        self.nameLabel.backgroundColor = UIColor.greenColor()
        self.nameLabel.numberOfLines = 0 // unlimited # of lines, "bleed" over to next
        
        // Button setup
        self.button = UIButton.init(frame: CGRect(x: 0, y: 0, width: 100, height: 10))
//        self.button.backgroundColor = UIColor.clearColor()
        self.button.backgroundColor = UIColor.purpleColor()
        
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: CardView.height))
        
        // Styling the card backdrop
        self.backgroundColor = UIColor.blueColor()
        
        // Connecting the button to an action in the CardView class
        self.button.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
        
        // Adding subviews to this cardview
        self.addSubview(self.imageView)
        self.addSubview(self.nameLabel)
        self.addSubview(self.button)
    }
    
    /**
     If the parent frame updated, or if the card itself updated (in terms of position, or size),
     we have to redraw the frame to fit its own subviews
    */
    func redraw() {
        if let parentview = self.superview {
            self.imageView.frame = CGRect(x: 0, y: 0, width: parentview.bounds.width, height: CardView.imageHeight)
            
            self.nameLabel.frame = CGRect(x: CardView.textMargin, y: CardView.imageHeight + CardView.textMargin, width: parentview.bounds.width - (2 * CardView.textMargin), height: CardView.textHeight)
            self.nameLabel.sizeToFit() // Now fit the frame to only what's needed. Also top aligns text to frame
            
            self.button.frame = CGRect(x: parentview.bounds.width - CardView.buttonWidth, y: CardView.imageHeight, width: CardView.buttonWidth, height: CardView.height - CardView.imageHeight)
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        // NSCoder allows something to be quickly deserialized into data and archived into a network
        // ...which isn't necessary for this UIView since it gets changed all the time anyway
        fatalError("init(coder:) has not been implemented")
    }

}









