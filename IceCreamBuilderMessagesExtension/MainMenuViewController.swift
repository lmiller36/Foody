//
//  MainMenuViewController.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by Lorne Miller on 10/22/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

import UIKit
import Messages

class MainMenuViewController :UIViewController{
    
    //  @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var Logo: UILabel!
    
    @IBOutlet weak var Continue: UIButton!
    @IBOutlet weak var ContinueLabel: UILabel!
    
    @IBOutlet weak var NewSurveyView: UIView!
    @IBOutlet weak var NewSurvey: UIButton!
    @IBOutlet weak var NewSurveyLabel: UILabel!
    
    
    @IBOutlet weak var HelpView: UIView!
    @IBOutlet weak var Help: UIButton!
    @IBOutlet weak var HelpLabel: UILabel!
    
    @IBOutlet weak var SettingsView: UIView!
    @IBOutlet weak var Settings: UIButton!
    @IBOutlet weak var SettingsLabel: UILabel!
    
    @IBOutlet weak var MadeByLorne: UILabel!
    weak var delegate: MainMenuViewControllerDelegate?
    
    static let storyboardIdentifier = "MainMenuViewController"
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    override func viewDidLoad() {
        
        //if view is compact, hide buttons
        let viewIsCompact = MessagesViewController.presentationStyle == MSMessagesAppPresentationStyle.compact
        
        self.NewSurveyView.isHidden = viewIsCompact
        self.SettingsView.isHidden = viewIsCompact
        self.HelpView.isHidden = viewIsCompact
        
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    @IBAction func AddNewSurvey(_ sender: UIGestureRecognizer) {
        
        Survey.sharedInstance.appState = AppState.CategorySelection
        delegate?.switchState_StartMenu()
    }
    
}

class ScrollingFoodCell : UICollectionViewCell{
    static let reuseIdentifier = "ScrollingFoodCell"
    
    @IBOutlet weak var Foooood: UILabel!
    
    
}

// A delegate protocol for the `IceCreamsViewController` class

protocol MainMenuViewControllerDelegate: class {
    
    /// Called to start a new survey
    func switchState_StartMenu()
    
}
