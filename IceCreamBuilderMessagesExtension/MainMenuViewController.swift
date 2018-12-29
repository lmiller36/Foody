//
//  MainMenuViewController.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by Lorne Miller on 10/22/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

import UIKit


class MainMenuViewController :UIViewController{
    
  //  @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var Logo: UILabel!
    
    @IBOutlet weak var Continue: UIButton!
    @IBOutlet weak var ContinueLabel: UILabel!
    
    @IBOutlet weak var NewSurvey: UIButton!
    @IBOutlet weak var NewSurveyLabel: UILabel!
    
    @IBOutlet weak var Help: UIButton!
    @IBOutlet weak var HelpLabel: UILabel!
    
    @IBOutlet weak var Settings: UIButton!
    @IBOutlet weak var SettingsLabel: UILabel!
    
    @IBOutlet weak var MadeByLorne: UILabel!
    weak var delegate: MainMenuViewControllerDelegate?
    
    static let storyboardIdentifier = "MainMenuViewController"
    

    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        //#TODO fix magic number
        
//        self.Logo.font = UIFont.systemFont(ofSize: CGFloat((MainMenu.headerHeight * 4) / 5))
//        self.Logo.adjustsFontSizeToFitWidth = true
//        self.Logo.frame = CGRect.init(x:0,y:0,width:Int(Screen.sharedInstance.width()), height:MainMenu.headerHeight)
//        self.Logo.center = CGPoint(x: Screen.sharedInstance.centerWidth(), y: Screen.sharedInstance.height() * 0.1)
//        self.Logo.numberOfLines = 0
//        self.Logo.minimumScaleFactor = 0.1
//        self.Logo.baselineAdjustment = .alignCenters
//        self.Logo.textAlignment  = .center
//
//
////        ScrollView.frame = CGRect.init(x:0,y:MainMenu.headerHeight,width:Int(Screen.sharedInstance.width()), height:MainMenu.frameHeight)
////        ScrollView.contentSize = CGSize(width: ScrollView.contentSize.width, height:  Screen.sharedInstance.height())
//        print(Screen.sharedInstance.width())
//        print(Screen.sharedInstance.height())
////        ScrollView.center = CGPoint(x: Screen.sharedInstance.width()/2, y: MainMenu.headerHeight + MainMenu.frameHeight / 2)
//        Continue.isHidden = true
//        ContinueLabel.isHidden = true
//
//        NewSurvey.center = CGPoint(x:Screen.sharedInstance.centerWidth(),y : 10)
//
//
//        let fontSizeForLorne = Screen.sharedInstance.height() * 0.05
//        self.MadeByLorne.textAlignment = .center
////        self.MadeByLorne.frame = CGRect.init(x:0,y:Screen.sharedInstance.height() * 0.05,width:Int(Screen.sharedInstance.width()), height:MainMenu.headerHeight)
//        self.MadeByLorne.font = UIFont.systemFont(ofSize: fontSizeForLorne * 0.8 )
//        self.MadeByLorne.center = CGPoint(x:Screen.sharedInstance.centerWidth(),y : Screen.sharedInstance.height() - fontSizeForLorne)
//        self.MadeByLorne.frame = CGRect.init(x:0,y:Int(Screen.sharedInstance.height() - 3 * fontSizeForLorne),width:Int(Screen.sharedInstance.width()), height: Int(fontSizeForLorne))

    }
    

    
    
    @IBAction func AddNewSurvey(_ sender: UIGestureRecognizer) {
        print("Add new survey")
        print(sender)
        delegate?.switchState_StartMenu(newState: AppState.CategorySelection)
    }
    
    
    
    
    
}

//class ScrollingFoodDataSource: UICollectionViewDataSource {
//
//     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 0
//    }
//
//     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//
//        return dequeueIceCreamCell(for: "", at: indexPath)
//
//    }
//
//
//
//     func dequeueIceCreamCell(for restaurantType: String, at indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: ScrollingFoodCell.reuseIdentifier,
//                                                             for: indexPath) as? ScrollingFoodCell
//            else { fatalError("Unable to dequeue am IceCreamCell") }
//
//
//
//
//
//        return cell
//    }
//
//
//}

class MainMenu{
    static let headerHeight = Int(0.3 * Screen.sharedInstance.height())
    static let frameHeight = Int(Screen.sharedInstance.height()) - MainMenu.headerHeight
    static let buttonLength = Int(0.1 * Screen.sharedInstance.height())
}

class ScrollingFoodCell : UICollectionViewCell{
    static let reuseIdentifier = "ScrollingFoodCell"
    
    @IBOutlet weak var Foooood: UILabel!
    
    
}

// A delegate protocol for the `IceCreamsViewController` class

protocol MainMenuViewControllerDelegate: class {
    
    /// Called to start a new survey
    func switchState_StartMenu(newState:AppState)
    
}
