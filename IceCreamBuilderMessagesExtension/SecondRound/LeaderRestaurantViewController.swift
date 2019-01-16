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
    
    var diningOptions = [DiningOption]()
    
    weak var delegate: LeaderRestaurantViewDelegate?
    
    static let storyboardIdentifier = "LeaderRestaurantViewController"
    
    override func viewDidLoad() {
        //#TODO break out into a method
        if(RestaurantsNearby.sharedInstance.isEmpty()){
            
            //get current location
            CurrentLocation.sharedInstance.lookUpCurrentLocation(callback: { (location) in
                guard let locationCoordinates = CurrentLocation.sharedInstance.getCurrentLocation()?.coordinate else {fatalError("Could not get current location")}
                
                let firstRoundChoice = Survey.sharedInstance.getCategoryWinner()
                guard let grouping = Grouping.init(rawValue:firstRoundChoice.title) else {fatalError("Illegal grouping")}
                
                //fix
                let categories = Cuisines.getCuisine(grouping: grouping).applicableCategories.map({ (icon) -> String in
                    return icon.rawValue
                })
                
                print(categories)
                
                let yelpRequest = YelpRequest.init(coordinates: locationCoordinates, result_limit: 50, radius_in_meters: 10000, categories: categories,sortAttribute: SortAttribute.best_match)
                
                yelpRequest.getNearbyRestaurants(callback :{ (restaurants) in
                    print(restaurants.map{$0.name})
                    
                    DispatchQueue.main.async {
                        RestaurantsNearby.sharedInstance.addRestaurants(restaurants: restaurants)
                        self.populateData()
                        print(self.visibleDiningOptions)
                        print(self.diningOptions)
                    }
                })
                
            })
        }
        
        
        
    }
    
    func populateData(){
        
        //# TODO do not fail if less than 3!!!
        self.diningOptions = RestaurantsNearby.sharedInstance.getRestaurants()
        
        let option1 = self.diningOptions.removeFirst()
        let option2 = self.diningOptions.removeFirst()
        let option3 = self.diningOptions.removeFirst()
        
        self.visibleDiningOptions.append(option1)
        self.visibleDiningOptions.append(option2)
        self.visibleDiningOptions.append(option3)
        
        self.VisibleRestaurants.reloadData()
        
    }
    
    
}

extension LeaderRestaurantViewController : UICollectionViewDataSource {
    //#TODO fix to remove hard coded
    //will always show 3 options, unless they are not 3 possible options
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleDiningOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return dequeueVoteCell( at: indexPath)
        
    }
    
    
    
    private func dequeueVoteCell( at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = VisibleRestaurants.dequeueReusableCell(withReuseIdentifier: LeaderRestaurantCell.reuseIdentifier,
                                                                for: indexPath) as? LeaderRestaurantCell
            else { fatalError("Unable to dequeue a LeaderRestaurantCell") }
        
        let row = indexPath.row
        let diningOption = visibleDiningOptions[row]
        //Icon and title
        cell.IconTitle.text = diningOption.title
        cell.Icon.image = diningOption.image
        
        //Restaurant Info
        cell.RestaurantName.text = diningOption.restaurant?.name
        
        //Address
        if let address = diningOption.restaurant?.location.address1 {
            cell.Statement1.text = String(address)
        }
        
        //Distance
        if let distanceInMeters = diningOption.restaurant?.distance {
                    let distanceInMiles =  Measurement(value: distanceInMeters, unit: UnitLength.meters).converted(to: UnitLength.miles).value
            cell.Statement2.text = String(format: "%.1f", distanceInMiles)+" miles"
        }
        
        //Rating and price
        
        guard let price = diningOption.restaurant?.price else {return cell}
        guard let rating = diningOption.restaurant?.rating else {return cell}

        print(rating)
        
        let ratingInStars = String(RestaurantsNearby.getRatingInStars(rating: rating))
        
        let statement3 = ratingInStars+" "+price
        let textColor = UIColor.init(red: 133/255, green: 187/255, blue: 101/255, alpha: 1.0)

        let range = (statement3 as NSString).range(of: price)
        
        let attribute = NSMutableAttributedString.init(string: statement3)
        attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: textColor , range: range)

        cell.Statement3.attributedText = attribute
        
        return cell
    }
}


class LeaderRestaurantCell : UICollectionViewCell {
    static let reuseIdentifier = "LeaderRestaurantCell"
    
    @IBOutlet weak var Icon: UIImageView!
    @IBOutlet weak var IconTitle: UILabel!
    
    @IBOutlet weak var RankingIcon: UIButton!
    
    @IBOutlet weak var RestaurantName: UILabel!
    @IBOutlet weak var Statement1: UILabel!
    @IBOutlet weak var Statement2: UILabel!
    @IBOutlet weak var Statement3: UILabel!
    
    @IBOutlet weak var UpArrow: UIButton!
    @IBOutlet weak var DownArrow: UIButton!
    
    @IBOutlet weak var RemoveOption: UIButton!
    
}

protocol LeaderRestaurantViewDelegate: class {
    
    
    func backToMainMenu()
    
    func addMessageToConversation(_ vote1:Vote,vote2:Vote,vote3:Vote, caption:String)
    
    func changePresentationStyle(presentationStyle:MSMessagesAppPresentationStyle)
    
}
