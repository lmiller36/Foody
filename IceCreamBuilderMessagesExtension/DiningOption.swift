//
//  DiningOption.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by user on 1/3/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit

/// Display information for a collectionview item
///
///
/// Parameters:
/// - **cuisine**: Cuisine type of the given dining option
/// - **image**: Icon for the given cuisine
/// - **restaurant**: Applicable restaurant information, if available
struct DiningOption {
    
    let cuisine : String
    let image : UIImage
    let restaurant : RestaurantInfo?
}
