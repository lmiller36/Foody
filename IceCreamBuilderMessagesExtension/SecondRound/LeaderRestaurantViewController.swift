//
//  LeaderRestaurantViewController.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by user on 1/4/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit
import Messages

class LeaderRestaurantViewController : UIViewController {
    
    @IBOutlet weak var VisibleRestaurants: UICollectionView!
    
    var visibleDiningOptions = [DiningOption]()
    
    //TODO: Reconstruct using DiningOptionTuplet
    var diningOptions = [DiningOption]()
    
    var queryString : String?
    
    weak var delegate: LeaderRestaurantViewDelegate?
    
    static let storyboardIdentifier = "LeaderRestaurantViewController"
    
    

    //TODO: Comment header
    /// Some introductory test that describes the purpose
    /// of the function.
    
    /**
     Another useful function
     - parameter alpha: Describe the alpha param
     - parameter beta: Describe the beta param
     */
    
    override func viewDidLoad() {
        //#TODO break out into a method
        if(RestaurantsNearby.sharedInstance.isEmpty()){
            
            //get current location
            CurrentLocation.sharedInstance.lookUpCurrentLocation(callback: { (location) in
                
                //Get user's current location
                guard let locationCoordinates = CurrentLocation.sharedInstance.getCurrentLocation()?.coordinate else {fatalError("Could not get current location")}
                
                //Retrieve winner of round 1
                let firstRoundChoice = Survey.sharedInstance.getCategoryWinner()
                guard let grouping = Grouping.init(rawValue:firstRoundChoice.cuisine) else {fatalError("Illegal grouping")}
                
                //Create list of applicable restaurant category's
                let categories = Cuisines.getCuisine(grouping: grouping).applicableCategories.map({ (icon) -> String in
                    return icon.rawValue
                })
                
                //Initialize yelp request
                let yelpRequest = YelpRequest.init(coordinates: locationCoordinates, result_limit: 50, radius_in_meters: 10000, categories: categories,sortAttribute: SortAttribute.best_match)
                
                let base_url = yelpRequest.request_url()
                self.queryString = base_url
                
                //Make API call to Yelp
                getNearbyRestaurants(base_url:base_url,callback :{ (restaurants) in
                    print(restaurants.map{$0.name})
                    
                    //Add restaurants to shared instance
                    DispatchQueue.main.async {
                        RestaurantsNearby.sharedInstance.addRestaurants(restaurants: restaurants)
                        //Repopulate view
                        self.populateData()
                        
                    }
                })
                
            })
        }
        else {
            //Repopulate view
            DispatchQueue.main.async {
                self.populateData()
            }
        }
        
    }
    

    //TODO: Comment header
    /// Some introductory test that describes the purpose
    /// of the function.
    
    /**
     Another useful function
     - parameter alpha: Describe the alpha param
     - parameter beta: Describe the beta param
     */
    
    func populateData(){
        
        //# TODO do not fail if less than 3!!!
        self.diningOptions = RestaurantsNearby.sharedInstance.getRestaurants()
        
        let option1 = self.diningOptions.removeFirst()
        let option2 = self.diningOptions.removeFirst()
        let option3 = self.diningOptions.removeFirst()
        
        self.visibleDiningOptions.append(option1)
        self.visibleDiningOptions.append(option2)
        self.visibleDiningOptions.append(option3)
        
        self.reload()
    }
    
    //TODO: Comment header
    /// Some introductory test that describes the purpose
    /// of the function.
    
    /**
     Another useful function
     - parameter alpha: Describe the alpha param
     - parameter beta: Describe the beta param
     */
    func getRankingIcon(index:Int) -> UIImage {
        switch(index){
        case 0:
            return UIImage(named: "gold-medal.png")!
        case 1:
            return UIImage(named: "silver-medal.png")!
        case 2:
            return UIImage(named: "bronze-medal.png")!
        default:
            fatalError("Index out of bounds error")
        }
    }
    
    //TODO: Comment header
    /// Some introductory test that describes the purpose
    /// of the function.
    
    /**
     Another useful function
     - parameter alpha: Describe the alpha param
     - parameter beta: Describe the beta param
     */
    
    func reload(){
        DispatchQueue.main.async {
            
            self.VisibleRestaurants.reloadData()
        }
    }
    
    //TODO: Comment header
    /// Some introductory test that describes the purpose
    /// of the function.
    
    /**
     Another useful function
     - parameter alpha: Describe the alpha param
     - parameter beta: Describe the beta param
     */
    
    func removeRestaurant(index:Int){
        if(index < 0 || index >= visibleDiningOptions.count){fatalError("Index out of bounds error")}

        //only remove if remaining options are still available
        if(!self.diningOptions.isEmpty) {
        visibleDiningOptions.remove(at: index)
        let option = self.diningOptions.removeFirst()
    
        self.visibleDiningOptions.append(option)
            
            self.reload()

            
        }
    }
    
    //TODO: Comment header
    /// Some introductory test that describes the purpose
    /// of the function.
    
    /**
     Another useful function
     - parameter alpha: Describe the alpha param
     - parameter beta: Describe the beta param
     */
    
    func swapRestaurants(index1:Int,index2:Int){
        if(index1 < 0 || index2 < 0 || index1 >= visibleDiningOptions.count ||  index2 >= visibleDiningOptions.count){fatalError("Index out of bounds error")}
        
        let option1 = visibleDiningOptions[index1]
        let option2 = visibleDiningOptions[index2]
        
        visibleDiningOptions[index2] = option1
        visibleDiningOptions[index1] = option2
        
        self.reload()
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
        
         let firstSelection = visibleDiningOptions[0]
        let secondSelection = visibleDiningOptions[1]
         let thirdSelection = visibleDiningOptions[2]
        
        //by nature, all of the leaders selection are approved
        let vote1 = Vote.init(cuisine: firstSelection.cuisine, restaurantId: firstSelection.restaurant?.id, approved: true, ranking: 1)
        
        let vote2 = Vote.init(cuisine: secondSelection.cuisine, restaurantId: secondSelection.restaurant?.id, approved: true, ranking: 2)
        
        let vote3 = Vote.init(cuisine: thirdSelection.cuisine, restaurantId: thirdSelection.restaurant?.id, approved: true, ranking: 3)
        
        guard let queryString = self.queryString else {fatalError(
            "No query string present")}
        
        Survey.sharedInstance.setLeaderRestaurantSelection(leaderSelection: [vote1,vote2,vote3], queryString: queryString)
        
        delegate?.addMessageToConversation(vote1,vote2: vote2,vote3: vote3,queryString: queryString, caption: "Here's which restaurants Paul likes")
        
    }
    
    
    
}

extension LeaderRestaurantViewController : UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleDiningOptions.count
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
        guard let cell = VisibleRestaurants.dequeueReusableCell(withReuseIdentifier: LeaderRestaurantCell.reuseIdentifier,
                                                                for: indexPath) as? LeaderRestaurantCell
            else { fatalError("Unable to dequeue a LeaderRestaurantCell") }
        
        let row = indexPath.row
        let diningOption = visibleDiningOptions[row]
        
        //Icon and title
        cell.IconTitle.text = diningOption.cuisine
        cell.Icon.image = diningOption.image
        
        //Ranking icon
        cell.RankingIcon.image = self.getRankingIcon(index: row)
        
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
        
        //remove option
        
        cell.RemoveOption.addTarget(self, action: #selector(remove), for: .touchUpInside)

        
        //hide applicable arrows
        
        //Up Arrow
        //is NOT visible
        if(row < 1) {
            cell.UpArrow.isHidden = true
        }
            //is visible
        else {
            cell.UpArrow.isHidden = false
            cell.UpArrow.addTarget(self, action: #selector(uptap), for: .touchUpInside)
        }
        
        //Down Arrow
        //is NOT visible
        if(row >= visibleDiningOptions.count - 1 ) {
            cell.DownArrow.isHidden = true
        }
            //is visible
        else {
            cell.DownArrow.isHidden = false
            cell.DownArrow.addTarget(self, action: #selector(downtap), for: .touchUpInside)
            
        }
        return cell
    }
    
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    @objc private func downtap(_ sender:  UIButton!){
        
        guard let cell = sender.superview?.superview as? LeaderRestaurantCell else {
            fatalError("Cell not found")
        }
        
        guard let indexPath = VisibleRestaurants.indexPath(for: cell) else {fatalError("Index path not found")}
        let row = indexPath.row
        
        self.swapRestaurants(index1: row, index2: row + 1)
  
    }
    
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    @objc private func uptap(_ sender:  UIButton!){
        guard let cell = sender.superview?.superview as? LeaderRestaurantCell else {
            fatalError("Cell not found")
        }
        
        guard let indexPath = VisibleRestaurants.indexPath(for: cell) else {fatalError("Index path not found")}
        let row = indexPath.row
        
        self.swapRestaurants(index1: row, index2: row - 1)
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    @objc private func remove(_ sender:  UIButton!){
        guard let cell = sender.superview?.superview as? LeaderRestaurantCell else {
            fatalError("Cell not found")
        }
        
        guard let indexPath = VisibleRestaurants.indexPath(for: cell) else {fatalError("Index path not found")}
        let row = indexPath.row
        
        self.removeRestaurant(index:row)
    }
    
}


class LeaderRestaurantCell : UICollectionViewCell {
    static let reuseIdentifier = "LeaderRestaurantCell"
    
    @IBOutlet weak var Icon: UIImageView!
    @IBOutlet weak var IconTitle: UILabel!
    
    @IBOutlet weak var RankingIcon: UIImageView!
    
    @IBOutlet weak var RestaurantName: UILabel!
    @IBOutlet weak var Statement1: UILabel!
    @IBOutlet weak var Statement2: UILabel!
    @IBOutlet weak var Statement3: UILabel!
    @IBOutlet weak var Statement4: UILabel!
    
    @IBOutlet weak var UpArrow: UIButton!
    @IBOutlet weak var DownArrow: UIButton!
    
    @IBOutlet weak var RemoveOption: UIButton!
    
}

protocol LeaderRestaurantViewDelegate: class {
    
    
    func backToMainMenu()
    
    func addMessageToConversation(_ vote1:Vote,vote2:Vote,vote3:Vote,queryString:String?, caption:String)
    
    func changePresentationStyle(presentationStyle:MSMessagesAppPresentationStyle)
    
}
