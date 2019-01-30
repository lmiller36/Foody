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

//TODO: Add feature to sort by different quantifiers (ie brunch, dinner, etc)
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        loadAll()
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    func loadAll(){
        
        
        let option1 = Cuisines.sharedInstance.removeItem(index: 0)
        let option2 = Cuisines.sharedInstance.removeItem(index: 0)
        let option3 = Cuisines.sharedInstance.removeItem(index: 0)
        
        let newDiningTuplet = DiningOptions.init(diningOptions: [option1, option2, option3])
        Survey.sharedInstance.firstRoundOptions = newDiningTuplet
        
        update()
        
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    func update(){
        
        guard let diningTuplet = Survey.sharedInstance.firstRoundOptions else {fatalError("No option present")}
        
        Icon1.image = diningTuplet.diningOptions[0].image
        Label1.text = diningTuplet.diningOptions[0].cuisine
        
        Icon2.image = diningTuplet.diningOptions[1].image
        Label2.text = diningTuplet.diningOptions[1].cuisine
        
        Icon3.image = diningTuplet.diningOptions[2].image
        Label3.text = diningTuplet.diningOptions[2].cuisine
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    @IBAction func Remove1(_ sender: Any) {
        
        removeCuisine(index: 0)

    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    @IBAction func Remove2(_ sender: Any) {
        
        removeCuisine(index: 1)

    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    @IBAction func Remove3(_ sender: Any) {
    removeCuisine(index: 2)
    }
    
    func removeCuisine(index : Int){
        if(Cuisines.sharedInstance.getAvailableRestaurauntGroupsCount() > 0 ) {
            
            if var visibleSelection = Survey.sharedInstance.firstRoundOptions {
                visibleSelection.diningOptions.remove(at: index)
                visibleSelection.diningOptions.append(Cuisines.sharedInstance.removeItem(index: 0))
            }
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
    @IBAction func SubmitSelection(_ sender: Any) {
        print(Survey.sharedInstance.firstRoundOptions)

        delegate?.addMessageToConversation(caption: "Here's what Paul is in the mood for")
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    @IBAction func Swap12(_ sender: Any) {
        
        Survey.sharedInstance.firstRoundOptions?.diningOptions.swapAt(0,1)
        update()
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    @IBAction func Swap23(_ sender: Any) {
        
         Survey.sharedInstance.firstRoundOptions?.diningOptions.swapAt(1,2)
       
        update()
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    @IBAction func Shuffle(_ sender: Any) {
        Cuisines.sharedInstance.shuffle()
        loadAll()
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


protocol LeaderVotingViewControllerDelegate: class {
    
    /// Called when a user choses to add a new `IceCream` in the `IceCreamsViewController`.
    
    func backToMainMenu()
    
    func addMessageToConversation(caption:String)
    
    func changePresentationStyle(presentationStyle:MSMessagesAppPresentationStyle)
    
}


