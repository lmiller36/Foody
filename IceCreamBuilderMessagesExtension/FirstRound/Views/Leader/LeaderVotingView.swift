//
//  LeaderVotingView.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by user on 12/26/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit
import Messages

class LeaderVotingViewController:UIViewController{
    static let storyboardIdentifier = "LeaderVotingViewController"
    
    @IBOutlet weak var Icon1: UIImageView!
    @IBOutlet weak var Icon2: UIImageView!
    @IBOutlet weak var Icon3: UIImageView!
    
    
    @IBOutlet weak var Label1: UILabel!
    @IBOutlet weak var Label2: UILabel!
    @IBOutlet weak var Label3: UILabel!
    
    
    @IBOutlet weak var Queue: UICollectionView!
    
    weak var delegate: LeaderVotingViewControllerDelegate?
    
    var diningOptionTuplet : DiningOptionTuplet?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        loadAll()
    }
    
    func loadAll(){
        
        
        let option1 = Cuisines.sharedInstance.removeItem(index: 0)
        let option2 = Cuisines.sharedInstance.removeItem(index: 0)
        let option3 = Cuisines.sharedInstance.removeItem(index: 0)
        
        let newDiningTuplet = DiningOptionTuplet.init(option1: option1, option2: option2, option3: option3)
        
        self.diningOptionTuplet = newDiningTuplet
        
        update()
        
    }
    
    func update(){
        
        guard let diningTuplet = self.diningOptionTuplet else {fatalError("No option present")}
        
        Icon1.image = diningTuplet.option1.image
        Label1.text = diningTuplet.option1.cuisine
        
        Icon2.image = diningTuplet.option2.image
        Label2.text = diningTuplet.option2.cuisine
        
        Icon3.image = diningTuplet.option3.image
        Label3.text = diningTuplet.option3.cuisine
    }
    
    @IBAction func Remove1(_ sender: Any) {
        //Can only remove an option if remaining options available
        
        if(Cuisines.sharedInstance.getAvailableRestaurauntGroupsCount() > 0 ) {
            
            guard let option2 = self.diningOptionTuplet?.option2 else {fatalError("No option 2")}
            
            self.diningOptionTuplet?.option1 = option2
            update()
            Remove2((Any).self)
        }
    }
    
    @IBAction func Remove2(_ sender: Any) {
        //Can only remove an option if remaining options available
        if(Cuisines.sharedInstance.getAvailableRestaurauntGroupsCount() > 0) {
            guard let option3 = self.diningOptionTuplet?.option3 else {fatalError("No option 3")}
            self.diningOptionTuplet?.option2 = option3
            Remove3((Any).self)
        }
    }
    
    @IBAction func Remove3(_ sender: Any) {
        if(Cuisines.sharedInstance.getAvailableRestaurauntGroupsCount() > 0) {
            self.diningOptionTuplet?.option3 = Cuisines.sharedInstance.removeItem(index: 0)
            update()
        }
        
    }
    
    
    
    @IBAction func SubmitSelection(_ sender: Any) {
        guard let firstSelection = Label1.text else {fatalError("No first selection")}
        guard let secondSelection = Label2.text else {fatalError("No second selection")}
        guard let thirdSelection = Label3.text else {fatalError("No third selection")}
        
        //by nature, all of the leaders selection are approved
        let vote1 = Vote.init(cuisine: firstSelection, restaurantId: Optional<String>.none, approved: true, ranking: 1)
        
        let vote2 = Vote.init(cuisine: secondSelection, restaurantId: Optional<String>.none, approved: true, ranking: 2)
        
        let vote3 = Vote.init(cuisine: thirdSelection, restaurantId: Optional<String>.none, approved: true, ranking: 3)
        
        Survey.sharedInstance.setLeaderCategorySelection(leaderSelection: [vote1,vote2,vote3])
        
        delegate?.addMessageToConversation(vote1,vote2: vote2,vote3: vote3,queryString: Optional<String>.none,caption: "Here's what Paul is in the mood for")
    }
    
    @IBAction func Swap12(_ sender: Any) {
        
        guard let currentDiningTuplet = self.diningOptionTuplet else {fatalError("No current dining tuplet")}
        
        let newDiningTuplet = DiningOptionTuplet.init(option1: currentDiningTuplet.option2, option2: currentDiningTuplet.option1, option3: currentDiningTuplet.option3)
        
        self.diningOptionTuplet = newDiningTuplet
        
        update()
    }
    
    
    @IBAction func Swap23(_ sender: Any) {
        
        guard let currentDiningTuplet = self.diningOptionTuplet else {fatalError("No current dining tuplet")}
        
        let newDiningTuplet = DiningOptionTuplet.init(option1: currentDiningTuplet.option1, option2: currentDiningTuplet.option3, option3: currentDiningTuplet.option2)
        
        self.diningOptionTuplet = newDiningTuplet
        
        update()
    }
    
    
    @IBAction func Shuffle(_ sender: Any) {
        Cuisines.sharedInstance.shuffle()
        loadAll()
    }
    
    @IBAction func Back_Main_Menu(_ sender: Any) {
        self.delegate?.backToMainMenu()
    }
    
    
}


protocol LeaderVotingViewControllerDelegate: class {
    
    /// Called when a user choses to add a new `IceCream` in the `IceCreamsViewController`.
    
    func backToMainMenu()
    
    func addMessageToConversation(_ vote1:Vote,vote2:Vote,vote3:Vote,queryString:String?, caption:String)
    
    func changePresentationStyle(presentationStyle:MSMessagesAppPresentationStyle)
    
}


