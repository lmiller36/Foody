//
//  SelectedRestaurant.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by Lorne Miller on 10/2/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit

class SelectedRestaurantCell : UICollectionViewCell{
    
    static let reuseIdentifier = "SelectedRestaurant"
    
  var representedIceCream: IceCream?
    
    @IBOutlet weak var RestaurantLabel: UILabel!

}
