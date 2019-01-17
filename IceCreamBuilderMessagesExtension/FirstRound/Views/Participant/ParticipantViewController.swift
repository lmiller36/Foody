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
    
    var categoryStates : [SelectionState]
    var diningTuplet : DiningOptionTuplet?
    
    
    @IBOutlet weak var AvailableTypes: UICollectionView!
    
    required init?(coder aDecoder: NSCoder) {
        self.categoryStates = [SelectionState]()
        
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
        self.categoryStates = [SelectionState.unselected,SelectionState.unselected,SelectionState.unselected]
        self.diningTuplet = Survey.sharedInstance.getFirstRoundOptions()
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    func switchSelectionState(index:Int){
        let currentState = categoryStates[index]
        let newState : SelectionState  =  {
            switch(currentState){
            
        case SelectionState.unselected:
            return SelectionState.approved
        case SelectionState.approved:
            return SelectionState.denied
        case SelectionState.denied:
            return SelectionState.approved
            }}()
        
        categoryStates[index] = newState
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    @objc private func SelectionTapped(_ sender: UITapGestureRecognizer){
        
        guard let indexPath = self.AvailableTypes?.indexPathForItem(at: sender.location(in: self.AvailableTypes)) else {return}
     
        switchSelectionState(index: indexPath.row)
        
        self.AvailableTypes.reloadData()
        
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    @IBAction func Submit(_ sender: Any) {
        
        var votedOnAllOptions = true
        
        self.showBorder = true
        
        guard let diningTuplet = self.diningTuplet else {fatalError("No saved dining tuplet")}
        
        for selectionState in self.categoryStates{
            votedOnAllOptions = votedOnAllOptions && (selectionState != SelectionState.unselected)
        }
        
        //can submit
        if(votedOnAllOptions)
        {
                    
        let vote1 = Vote.init(cuisine: diningTuplet.option1.cuisine, restaurantId: Optional<String>.none, approved: self.categoryStates[0].isApproved(), ranking: 1)
        
        let vote2 = Vote.init(cuisine: diningTuplet.option2.cuisine, restaurantId: Optional<String>.none, approved: self.categoryStates[1].isApproved(), ranking: 2)
        
        let vote3 = Vote.init(cuisine: diningTuplet.option3.cuisine, restaurantId: Optional<String>.none, approved: self.categoryStates[2].isApproved(), ranking: 3)
            
            self.delegate?.addMessageToConversation(vote1,vote2: vote2,vote3: vote3,queryString: Optional<String>.none, caption: "Lorne has voted")
        }
        else {
            self.AvailableTypes.reloadData()
        }
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    @IBAction func Back_Main_Menu(_ sender: Any) {
        self.delegate?.backToMainMenu()
    }
    
    
    
}


extension ParticipantViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categoryStates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return dequeueVoteCell( at: indexPath)
        
    }
    
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    private func dequeueVoteCell( at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = AvailableTypes.dequeueReusableCell(withReuseIdentifier: ParticipantVoteCell.reuseIdentifier,
                                                            for: indexPath) as? ParticipantVoteCell
            else { fatalError("Unable to dequeue a VoteCell") }
        
        let row = indexPath.row
        guard let diningTuplet = self.diningTuplet else {fatalError("No saved dining tuplet")}

        let diningOption = diningTuplet.getOption(index: row)
        
        cell.IconTitle.text = diningOption.cuisine
        cell.Icon.image = diningOption.image
        
        let state = self.categoryStates[row]
        
        
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
        
        cell.Info.text = ""
        cell.Statement1.text = ""
        cell.Statement2.text = ""
        cell.Statement3.text = ""
        
        let tapped = UITapGestureRecognizer(target: self, action: #selector(SelectionTapped))
        cell.Selection.addGestureRecognizer(tapped)
        
        return cell
    }
}

//TODO: header
public  enum SelectionState : String{
    case unselected
    case approved
    case denied
    
    func isApproved() -> Bool{
        return self == .approved
    }
    
}

class ParticipantVoteCell : UICollectionViewCell{
    static let reuseIdentifier = "ParticipantVoteCell"
    
    @IBOutlet weak var Icon: UIImageView!
    @IBOutlet weak var IconTitle: UILabel!
    
    @IBOutlet weak var Selection: UIButton!
    
    @IBOutlet weak var Info: UILabel!
    @IBOutlet weak var Statement1: UILabel!
    @IBOutlet weak var Statement2: UILabel!
    @IBOutlet weak var Statement3: UILabel!
    
}

protocol ParticipantVotingViewControllerDelegate: class {
    
    /// Called when a user choses to add a new `IceCream` in the `IceCreamsViewController`.
    
    func backToMainMenu()
    
    func addMessageToConversation(_ vote1:Vote,vote2:Vote,vote3:Vote,queryString:String?, caption:String)
    
    func changePresentationStyle(presentationStyle:MSMessagesAppPresentationStyle)
    
}
