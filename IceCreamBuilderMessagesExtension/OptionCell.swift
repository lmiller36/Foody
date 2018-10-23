//
//  OptionCell.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by Lorne Miller on 10/21/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit
import Messages

class OptionCell : UICollectionViewCell {
    
    static let reuseIdentifier = "OptionCell"
    var representedType : String?
    var representedIceCream : IceCream?
    
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Sticker: MSStickerView!
    
}
