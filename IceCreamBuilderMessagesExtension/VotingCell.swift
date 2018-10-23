//
//  VotingCell.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by Lorne Miller on 10/3/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

import UIKit
import Messages

class VotingCell:UICollectionViewCell {
    static let reuseIdentifier = "VotingCell"
    
    var restaurant:Restaurant?
    var thumbsUpObj : ThumbsUp?
    
    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var stickerView: MSStickerView!
    @IBOutlet weak var cellInfo: UILabel!
    
    @IBOutlet weak var statement1: UILabel!
    @IBOutlet weak var statement2: UILabel!
    @IBOutlet weak var statement3: UILabel!
    
    @IBOutlet weak var thumbsUp: UIImageView!
    
}
