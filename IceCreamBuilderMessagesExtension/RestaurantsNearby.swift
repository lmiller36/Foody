//
//  RestaurantsNearby.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by Lorne Miller on 9/28/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

class RestaurantsNearby{
    
    static let sharedInstance = RestaurantsNearby()
    
    private var restaurants:[Restaurant]
    private var selectedRows:[Int]
   // private var originalJson:String
    
    private static var sortCriteria = SortCriteria.Distance
    private var hasBeenSorted:Bool
    
   fileprivate init() {
        self.restaurants = [Restaurant]()
   // self.originalJson=""
    self.hasBeenSorted = false
    self.selectedRows = [Int]()
    }
    
    func getApplicableRestaurantCategories()->Dictionary<String,String>{
        var restaurantCategories = Dictionary<String,String>()
        for restaurant in restaurants {
            let category_title = restaurant.categories[0].title
            let category_alias = restaurant.categories[0].alias
            if(!restaurantCategories.keys.contains(category_alias)){
                 restaurantCategories[category_alias] = category_title
            }
           
        }
        return restaurantCategories
    }
    
    func add(restaurants:[Restaurant]){
        self.restaurants = restaurants
    }
    
    func add(restaurant:Restaurant){
        self.restaurants.append(restaurant)
    }
    
    func toggleTappedRestaurant(row:Int){
        if(selectedRows.contains(row)){
            selectedRows = selectedRows.filter { $0 != row }
        }
        else {
            selectedRows.append(row)
        }
    }
    
    //0 = not tapped , 1 tapped
    func getRowStatus(row:Int)->Int{
        if(selectedRows.contains(row))
        {
            return 1
        }
        return 0
    }
    
    func getSelectedRestaurant()->[Restaurant]{
        var selectedRestaurants = [Restaurant]()
        for row in selectedRows {
            selectedRestaurants.append(restaurants[row])
        }
        
        return selectedRestaurants
    }
    
    func getRestaurant(row:Int)->Restaurant?{
        do{
            let restaurant = self.restaurants[row]
        return restaurant
        }
        catch{
            print("row is out of bounds")
        }
        
        return Optional<Restaurant>.none
    }
    
    func clearAll(){
        self.restaurants.removeAll()
        self.selectedRows.removeAll()
    }
    
//    func setOriginalJson(string:String){
//        self.originalJson = string
//    }
    
//    func getOriginalJson()->String{
//        return self.originalJson
//    }
    
    func getIceCreams()->[IceCream]?{
        if(!self.hasBeenSorted){
                    self.sort(sortCriteria: RestaurantsNearby.sortCriteria)

            self.hasBeenSorted = true
        }
        
        var iceCreams:[IceCream] = []
        for restaraunt in restaurants{
            iceCreams.append(IceCream(base: getType(type:restaraunt.categories[0].alias), scoops: .scoops01, topping: .topping01,restaraunt:restaraunt,blackAndWhite:false))
        }
        return iceCreams
    }
    
    func sort(sortCriteria: SortCriteria) {
//        guard let restaurants = self.restaurants else{return}
      
        RestaurantsNearby.sortCriteria = sortCriteria
        switch sortCriteria {
            
        case SortCriteria.Distance:
            self.restaurants = restaurants.sorted(by: { $0.distance < $1.distance })
        case SortCriteria.Price:
            self.restaurants = restaurants.sorted(by: { String($0.price ?? "$$$$$$").count < String($1.price ?? "").count})
        case SortCriteria.Rating:
            self.restaurants = restaurants.sorted(by: { $0.rating > $1.rating })
        }
    }
    
    
//    func sortIfNecessary(){
//        if(!self.hasBeenSorted){
//            self.hasBeenSorted = true
//            self.sort(sortCriteria: RestaurantsNearby.SortCriteria.Distance)
//        }
//
//    }
    
    enum SortCriteria{
        case Distance
        case Price
        case Rating
    }
    
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
