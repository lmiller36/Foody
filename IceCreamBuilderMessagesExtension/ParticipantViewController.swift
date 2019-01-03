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
    
    weak var delegate: ParticipantVotingViewControllerDelegate?
    var showBorder = false
    
    var categoryStates : [Grouping: SelectionState]
    
    
    @IBOutlet weak var AvailableTypes: UICollectionView!
    
    required init?(coder aDecoder: NSCoder) {
        self.categoryStates = [Grouping: SelectionState]()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        for grouping in Categories.sharedInstance.currentOrdering{
            categoryStates[grouping] = SelectionState.unselected
        }
    }
    
    func switchState(grouping : Grouping){
        let currentState = categoryStates[grouping]
        let newState : SelectionState  =  {switch(currentState!){
            
        case SelectionState.unselected:
            return SelectionState.approved
        case SelectionState.approved:
            return SelectionState.denied
        case SelectionState.denied:
            return SelectionState.approved
            }}()
        
        categoryStates[grouping] = newState
        print(currentState)
        print(newState)
    }
    
    @objc private func SelectionTapped(_ sender: UITapGestureRecognizer){
        
        print("tapped image!")
        
        
        guard let indexPath = self.AvailableTypes?.indexPathForItem(at: sender.location(in: self.AvailableTypes)) else {return}
        guard let cell = self.AvailableTypes?.cellForItem(at: indexPath) as? ParticipantVoteCell else {return}
    
        let grouping = Grouping.init(rawValue: cell.IconTitle.text!)!
        switchState(grouping: grouping)
        
      
        self.AvailableTypes.reloadData()
        
    }
    
    @IBAction func Submit(_ sender: Any) {
        
        var votedOnAllOptions = true
        
//        var votes = [String:String]()
        self.showBorder = true
        
        var votes = [Vote]()
        
       let selection = self.categoryStates.filter({$0.value != SelectionState.unselected})
        print(selection)
    }
        
    @IBAction func Back_Main_Menu(_ sender: Any) {
         self.delegate?.backToMainMenu()
    }
    
    
    
}

//if let visibleCells = self.AvailableTypes?.visibleCells as? [UICollectionViewCell] {
//    for cell in visibleCells {
//        if let participantViewCell = cell as? ParticipantVoteCell {
//            //                    print(participantViewCell.IconTitle.text)
//            //                    participantViewCell.showBorder = true
//            //
//            //                    if (participantViewCell.state == SelectionState.unselected)
//            //                    {
//            //                        votedOnAllOptions = false
//            //                        participantViewCell.layer.borderColor = UIColor.red.cgColor
//            //                        participantViewCell.layer.borderWidth = 1
//            //                    }
//            //                    else {
//            //                        participantViewCell.layer.borderWidth = 0
//            //                        if let text = participantViewCell.IconTitle.text {
//            //                            votes[text] = String(participantViewCell.state.isApproved())
//            //                        }
//            //                    }
//
//        }
//    }

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
        
        let grouping = Grouping.init(rawValue: cell.IconTitle.text!)!
        let state = self.categoryStates[grouping] as! SelectionState
        
        let image : UIImage = {
            switch (state) {
                
            case .unselected:
                return UIImage(named: "thumbsUp_unselected.png")!
            case .approved:
                return UIImage(named: "thumbsUp_selected.png")!
            case .denied:
                return UIImage(named: "thumbsDown_selected.png")!
            }
        }()
        
        cell.Selection.setImage(image, for: .normal)
        
        if (state == SelectionState.unselected && self.showBorder)
        {
            cell.layer.borderColor = UIColor.red.cgColor
            cell.layer.borderWidth = 1
        }
        else {
            cell.layer.borderWidth = 0
        }
//
//                            if (self.categoryStates[representedRestaurantGroup.grouping] == SelectionState.unselected && self.showBorder)
//                            {
//
//                                cell.layer.borderColor = UIColor.red.cgColor
//                                cell.layer.borderWidth = 1
//                            }
//                            else {
//                                cell.layer.borderWidth = 0
//                                if let text = cell.IconTitle.text {
//                                    //votes[text] = String(participantViewCell.state.isApproved())
//                                }
//                            }
        
        cell.Info.text = ""
        cell.Statement1.text = ""
        cell.Statement2.text = ""
        cell.Statement3.text = ""
        
        let tapped = UITapGestureRecognizer(target: self, action: #selector(SelectionTapped))
        cell.Selection.addGestureRecognizer(tapped)
        
        return cell
    }
}

protocol ParticipantVotingViewControllerDelegate: class {
    
    /// Called when a user choses to add a new `IceCream` in the `IceCreamsViewController`.
    
    func backToMainMenu()
    
    func addMessageToConversation(_ vote1:Vote,vote2:Vote,vote3:Vote, caption:String)
    
    func changePresentationStyle(presentationStyle:MSMessagesAppPresentationStyle)
    
}
