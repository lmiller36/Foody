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
    
    @IBOutlet weak var ScrollingFood: UICollectionView!
    @IBOutlet weak var ScrollView: UIScrollView!
    
    weak var delegate: MainMenuViewControllerDelegate?
    
    static let storyboardIdentifier = "MainMenuViewController"
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        //#TODO fix magic number
        ScrollView.contentSize = CGSize(width: ScrollView.contentSize.width, height: 800)
        
    }
    
    @IBAction func AddNewSurvey(_ sender: UIGestureRecognizer) {
        print("Add new survey")
        print(sender)
        delegate?.switchState_StartMenu(newState: AppState.InitialSelection)
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

class ScrollingFoodCell : UICollectionViewCell{
    static let reuseIdentifier = "ScrollingFoodCell"
    
    @IBOutlet weak var Foooood: UILabel!
    
    
}

// A delegate protocol for the `IceCreamsViewController` class

protocol MainMenuViewControllerDelegate: class {
    
    /// Called to start a new survey
    func switchState_StartMenu(newState:AppState)
    
}
