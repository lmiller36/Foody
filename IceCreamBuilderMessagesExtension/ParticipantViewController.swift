//
//  ParticipantViewController.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by user on 12/28/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit
import Messages

class ParticipantViewController:UIViewController{
    static let storyboardIdentifier = "ParticipantViewController"

    @IBOutlet weak var AvailableTypes: UICollectionView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}

extension ParticipantViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Categories.sharedInstance.getAvailableRestaurauntGroupsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return dequeueVoteCell( at: indexPath)
        
    }
    
    
    
    private func dequeueVoteCell( at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = AvailableTypes.dequeueReusableCell(withReuseIdentifier: ParticipantVoteCell.reuseIdentifier,
                                                   for: indexPath) as? ParticipantVoteCell
            else { fatalError("Unable to dequeue a VoteCell") }
        
        let row = indexPath.row
        let representedRestaurantGroup =  Categories.sharedInstance.getRestaurantGroup(index: row)
        
        //cell.Info = representedRestaurantGroup.grouping.rawValue
        cell.IconTitle.text = representedRestaurantGroup.grouping.rawValue
        cell.Icon.image = representedRestaurantGroup.displayIcon.image
        
        cell.Info.text = ""
        cell.Statement1.text = ""
        cell.Statement2.text = ""
        cell.Statement3.text = ""
        
        return cell
    }
}

protocol ParticipantViewControllerDelegate: class {
    
    /// Called when a user choses to add a new `IceCream` in the `IceCreamsViewController`.
    
    func backToMainMenu()
    
    func addMessageToConversation(_ dictionary:[String:String],caption:String)
    
    func changePresentationStyle(presentationStyle:MSMessagesAppPresentationStyle)
    
}
