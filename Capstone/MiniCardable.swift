//
//  Cardable.swift
//  Capstone
//
//  Created by Angela Liu on 7/18/16.
//  Copyright © 2016 amliu. All rights reserved.
//

import Foundation
import UIKit

/**
 Anything that implements this can be shoved into a mini card UIView
*/
protocol MiniCardable {
    var minicardTitle: String { get }
    var cardImage: UIImage? { get }
    var categoryImage: UIImage? { get }
    var category: String { get }
    var additionalText: String? { get }
}