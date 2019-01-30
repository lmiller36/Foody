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
    var diningTuplet : DiningOptions?
    
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
        if(Survey.sharedInstance.appState == AppState.CategorySelection) {
            self.diningTuplet = Survey.sharedInstance.firstRoundOptions
            self.categoryStates = [SelectionState.unselected,SelectionState.unselected,SelectionState.unselected]

            DispatchQueue.main.async {
                self.AvailableTypes.reloadData()
            }
        }
        else {
        
                 DispatchQueue.main.async {
                    self.diningTuplet = Survey.sharedInstance.secondRoundOptions
                    print(self.diningTuplet)
                    self.categoryStates = [SelectionState.unselected,SelectionState.unselected,SelectionState.unselected]

                    self.AvailableTypes.reloadData()
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
//        
        self.showBorder = true
//
        guard let diningTuplet = self.diningTuplet else {fatalError("No saved dining tuplet")}
//
        var votes = [Vote2]()
        var count = 0
        for selectionState in self.categoryStates{
            votedOnAllOptions = votedOnAllOptions && (selectionState != SelectionState.unselected)
            let approved = selectionState == SelectionState.approved
            guard let diningOption = self.diningTuplet?.diningOptions[count] else {fatalError("Missing dining option")}
            
            let name = Survey.sharedInstance.appState == AppState.CategorySelection ?
            diningOption.cuisine : diningOption.restaurant!.id
            
            let vote = Vote2.init(name: name, voteBy: Survey.sharedInstance.participantUUID!,approved:approved)
            votes.append(vote)
            count += 1
        }
        
        print(votedOnAllOptions)

        //can submit
        if(votedOnAllOptions)
        {
     
            
            print(votes)
            
            Survey.sharedInstance.addVotes(votes: votes)

           self.delegate?.addMessageToConversation( caption: "Lorne has voted")
            
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
        return self.diningTuplet?.diningOptions.count ?? 0
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
        
        
        cell.RestaurantName.text = ""
        cell.Statement1.text = ""
        cell.Statement2.text = ""
        cell.Statement3.text = ""
        cell.Statement4.text = ""

        
        let tapped = UITapGestureRecognizer(target: self, action: #selector(SelectionTapped))
        cell.Selection.addGestureRecognizer(tapped)
        
        //used in second round
        if let restaurantInfo = diningOption.restaurant {
            cell.Statement1.text = restaurantInfo.displayPhone
            //Icon and title
            cell.IconTitle.text = diningOption.cuisine
            cell.Icon.image = diningOption.image
            
            
            //Restaurant Info
            cell.RestaurantName.text = diningOption.restaurant?.name
            
            //Address
            if let address = diningOption.restaurant?.location.address1 {
                cell.Statement1.text = String(address) + ","
            }
            
            //City
            if let address = diningOption.restaurant?.location.city {
                cell.Statement2.text = String(address)
            }
            
            //Distance
            if let distanceInMeters = diningOption.restaurant?.distance {
                let distanceInMiles =  Measurement(value: distanceInMeters, unit: UnitLength.meters).converted(to: UnitLength.miles).value
                cell.Statement3.text = String(format: "%.1f", distanceInMiles)+" miles"
            }
            
            //Rating and price
            guard let price = diningOption.restaurant?.price else {return cell}
            guard let rating = diningOption.restaurant?.rating else {return cell}
            
            let ratingInStars = String(RestaurantsNearby.getRatingInStars(rating: rating))
            
            let statement4 = ratingInStars+" "+price
            let textColor = UIColor.init(red: 133/255, green: 187/255, blue: 101/255, alpha: 1.0)
            
            let range = (statement4 as NSString).range(of: price)
            
            let attribute = NSMutableAttributedString.init(string: statement4)
            attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: textColor , range: range)
            
            cell.Statement4.attributedText = attribute
        }
        
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
    
    @IBOutlet weak var RestaurantName: UILabel!
    @IBOutlet weak var Statement1: UILabel!
    @IBOutlet weak var Statement2: UILabel!
    @IBOutlet weak var Statement3: UILabel!
    @IBOutlet weak var Statement4: UILabel!
}

protocol ParticipantVotingViewControllerDelegate: class {
    
    /// Called when a user choses to add a new `IceCream` in the `IceCreamsViewController`.
    
    func backToMainMenu()
    
    func addMessageToConversation(caption:String)
    
    func changePresentationStyle(presentationStyle:MSMessagesAppPresentationStyle)
    
}
