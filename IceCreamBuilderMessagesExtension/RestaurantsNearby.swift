//
//  RestaurantsNearby.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by Lorne Miller on 9/28/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

//TODO: class header
class RestaurantsNearby {
    
    static let sharedInstance = RestaurantsNearby()
    
    private var restaurants:[DiningOption]
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    fileprivate init() {
        
        self.restaurants = [DiningOption]()
        
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    func addRestaurants(restaurants : [RestaurantInfo]){
        for restaurant in restaurants {
            let title = restaurant.getCategory().title
            let image = getType(type: restaurant.getCategory().alias).image
            
            let diningOption = DiningOption.init(cuisine: title, image: image, restaurant: restaurant)
        
        self.restaurants.append(diningOption)
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
    func getRestaurantsByID(ids: [String]) -> [DiningOption] {
        let matching_restaurants = [DiningOption]()
        return self.restaurants.filter{$0.restaurant != nil && ids.contains(($0.restaurant?.id)!)}
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    func isEmpty() -> Bool{
        return restaurants.count == 0
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    func getRestaurants() -> [DiningOption]{
        return self.restaurants
    }
    
    //TODO: Description
    enum SortCriteria{
        case Distance
        case Price
        case Rating
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    static func getRatingInStars(rating:Double)->String{
        switch rating {
        case 0:
            return ""
        case 0.5:
            return "★☆☆☆☆"
        case 1.0:
            return "★☆☆☆☆"
        case 1.5:
            return "★★☆☆☆"
        case 2.0:
            return "★★☆☆☆"
        case 2.5:
            return "★★★☆☆"
        case 3.0:
            return "★★★☆☆"
        case 3.5:
            return "★★★★☆"
        case 4.0:
            return "★★★★☆"
        case 4.5:
            return "★★★★★"
        case 5.0:
            return "★★★★★"
        default:
            return ""
        }
    }
    
    

}
