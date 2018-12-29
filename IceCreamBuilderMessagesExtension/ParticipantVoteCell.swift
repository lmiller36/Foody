//
//  ParticipantVoteCell.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by user on 12/28/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit

class ParticipantVoteCell : UICollectionViewCell{
    static let reuseIdentifier = "ParticipantVoteCell"

    @IBOutlet weak var Icon: UIImageView!
    @IBOutlet weak var IconTitle: UILabel!

    @IBOutlet weak var Fork: UIButton!
    @IBOutlet weak var Spoon: UIButton!
    
    @IBOutlet weak var Info: UILabel!
    @IBOutlet weak var Statement1: UILabel!
    @IBOutlet weak var Statement2: UILabel!
    @IBOutlet weak var Statement3: UILabel!
}
