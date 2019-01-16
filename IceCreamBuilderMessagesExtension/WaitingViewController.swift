//
//  WaitingViewController.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by lorne on 10/26/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit

class WaitingViewController : UIViewController {
    static let storyboardIdentifier = "WaitingViewController"
    
    override func viewDidLoad() {
        print(Survey.readFromCache())
    }
    
}
