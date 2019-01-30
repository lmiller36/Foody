//
//  DoneViewController.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by user on 1/18/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

import UIKit
import Messages

class DoneViewController : UIViewController {
    
    
    @IBOutlet weak var Icon: UIImageView!
    @IBOutlet weak var Cuisine: UILabel!
    
    @IBOutlet weak var RestaurantName: UILabel!
    
    @IBOutlet weak var Address: UILabel!
    @IBOutlet weak var City: UILabel!
    @IBOutlet weak var Distance: UILabel!
    @IBOutlet weak var PriceAndRating: UILabel!
    
    static let storyboardIdentifier = "DoneViewController"
    weak var delegate: DoneViewDelegate?

    override func viewDidLoad() {
//         let winningRestaurant = Survey.sharedInstance.getWinningRestaurant()
//        
//        Cuisine.text = winningRestaurant.cuisine
//        Icon.image = winningRestaurant.image
//        
//        //Restaurant Info
//        RestaurantName.text = winningRestaurant.restaurant?.name
//        
//        //Address
//        if let address = winningRestaurant.restaurant?.location.address1 {
//            Address.text = String(address) + ","
//        }
//        
//        //City
//        if let city = winningRestaurant.restaurant?.location.city {
//            City.text = String(city)
//        }
//        
//        //Distance
//        if let distanceInMeters = winningRestaurant.restaurant?.distance {
//            let distanceInMiles =  Measurement(value: distanceInMeters, unit: UnitLength.meters).converted(to: UnitLength.miles).value
//            Distance.text = String(format: "%.1f", distanceInMiles)+" miles"
//        }
//        
//        //Rating and price
//        guard let price = winningRestaurant.restaurant?.price else {return}
//        guard let rating = winningRestaurant.restaurant?.rating else {return}
//        
//        let ratingInStars = String(RestaurantsNearby.getRatingInStars(rating: rating))
//        
//        let statement4 = ratingInStars+" "+price
//        let textColor = UIColor.init(red: 133/255, green: 187/255, blue: 101/255, alpha: 1.0)
//        
//        let range = (statement4 as NSString).range(of: price)
//        
//        let attribute = NSMutableAttributedString.init(string: statement4)
//        attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: textColor , range: range)
//        
//        PriceAndRating.attributedText = attribute
    }
    
}

protocol DoneViewDelegate: class {
    
    
    func backToMainMenu()
    
    func addMessageToConversation(caption:String)
    
    func changePresentationStyle(presentationStyle:MSMessagesAppPresentationStyle)
    
}
