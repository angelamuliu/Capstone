//
//  MiniCardView.swift
//  Capstone
//
//  Created by Angela Liu on 7/18/16.
//  Copyright © 2016 amliu. All rights reserved.
//

import Foundation
import UIKit

/** 
 Connects to the MiniCardView.xib file, which has its size set to "freeform" to allow for differing containers
 Note: To allow the xib to stack, you really gotta go hard with the constraints. Like, put them all on.
 
 To initialize EX:
 
 if let miniCard = NSBundle.mainBundle().loadNibNamed("MiniCardView", owner: self, options: nil).first as? MiniCardView {
    miniCard.useData(guide)
    contentStackView.addArrangedSubview(miniCard)
 }
 
*/
class MiniCardView : UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var extraTextLabel: UILabel!
    
    // TODO : Button to bring up whatever... probably pass in a function as a handler elsewhere
    
    var data: MiniCardable?
    
    // Since I couldn't find a good way to have the xib load with params passed in for initialization, use this to hook up
    // the data source
    func useData(data:MiniCardable) {
        self.data = data
        imageView.image = data.cardImage
        titleLabel.text = data.minicardTitle
        categoryImageView.image = data.categoryImage
        categoryLabel.text = data.category
        extraTextLabel.text = data.additionalText
    }
    
    // This is called when initializing from the xib and required
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}