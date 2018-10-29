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
    
    private var restaurants:[RestaurantInfo]
    private var selectedRows:[Int]
   // private var otherParticipantsSelection : [RestaurantInfo]
    private var votes: [String:Int]
    
    private var ignoredTypes : [String]
    
    // private var originalJson:String
    
    private static var sortCriteria = SortCriteria.Distance
    private var hasBeenSorted:Bool
    
    fileprivate init() {
        self.restaurants = [RestaurantInfo]()
        self.votes = [String:Int]()
        self.hasBeenSorted = false
        self.selectedRows = [Int]()
        self.ignoredTypes = [String]()
        //self.otherParticipantsSelection = [RestaurantInfo]()
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
    
    func add(restaurants:[RestaurantInfo]){
        self.restaurants = restaurants
    }
    
    func add(restaurant:RestaurantInfo){
        self.restaurants.append(restaurant)
    }
    
    func add(restaurant:RestaurantInfo,numVotes:Int){
        self.votes[restaurant.id] = getVotesForARestaurant(id: restaurant.id) + 1
        self.restaurants.append(restaurant)
    }
    
    func addIgnoredType(ignoredType:String){
        if(!self.ignoredTypes.contains(ignoredType)){
            self.ignoredTypes.append(ignoredType)
        }
    }
    
    func removeIgnoredType(typeToRemove:String){
        if let index = self.ignoredTypes.firstIndex(where: { $0.contains(typeToRemove) }) {
             self.ignoredTypes.remove(at: index)
        }
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
    
//    func getOtherParticipantsSelection()->[RestaurantInfo]{
//        return self.otherParticipantsSelection
//    }
    func addOtherParticipantsSelection(restaurantID : String,votes : Int){
       // self.otherParticipantsSelection.append(restaurant)
        self.votes[restaurantID] = votes
    }
    
    //queries based on id of the restaurant
    func getVotesForARestaurant(id:String)->Int{
        if let numVotes = votes[id] {
            return numVotes
        }
        return 0
    }
    
    func getVotes()->[String:Int]{
        return self.votes
    }
    
    func getSelectedRestaurant()->[RestaurantInfo]{
        var selectedRestaurants = [RestaurantInfo]()
        for row in selectedRows {
            selectedRestaurants.append(restaurants[row])
        }
        
        return selectedRestaurants
    }
    
    func getRestaurant(row:Int)->RestaurantInfo?{
        
        let restaurant = self.restaurants[row]
        return restaurant
        
    }
    
    func before(value1: String, value2: String) -> Bool {
        return self.votes[value1] ?? 0 > self.votes[value2] ?? 0
    }
    
    //TODO CHECK IF NOT FOUND RESTAURANTS ARE GETTING SKIPPED
    //combines the selection made by the current user as well as the other participants of the survey
    func getVotedOnRestaurants(numberOfRestaurantsToReturn:Int)->[RestaurantInfo]
    {
        var votesOnRestaurants = self.getSelectedRestaurant()
        
        let sortedVotes = self.votes.keys.sorted(by: before)
            
        print(sortedVotes)
        for restaurantId in self.votes.keys {
            let matchedRestaurantList = self.restaurants.filter({$0.id == restaurantId})
            if(matchedRestaurantList.count == 0)
            {
                print("ERROR, restaurant not Found")
            }
            else {
                votesOnRestaurants.append(matchedRestaurantList[0])
            }
            
        }
        
        var count = 0
        
        while(count < numberOfRestaurantsToReturn && count < self.votes.keys.count){
            let matchedRestaurantList = self.restaurants.filter({$0.id == sortedVotes[count]})
            if(matchedRestaurantList.count == 0)
            {
                print("ERROR, restaurant not Found")
            }
            else {
                votesOnRestaurants.append(matchedRestaurantList[0])
            }
            count += 1
        }
        
//        self.otherParticipantsSelection.mergeElements(newElements: self.getSelectedRestaurant())
        return votesOnRestaurants
    }
    
    func clearAll(){
        self.restaurants.removeAll()
        self.selectedRows.removeAll()
       // self.otherParticipantsSelection.removeAll()
    }
    
    func getKnownRestaurants ()-> [RestaurantInfo]{
        return self.restaurants
    }
    
    func getIceCreams()->[Restaurant]?{
        if(!self.hasBeenSorted){
            self.sort(sortCriteria: RestaurantsNearby.sortCriteria)
            
            self.hasBeenSorted = true
        }
        
        var iceCreams:[Restaurant] = []
        for restaraunt in restaurants{
            iceCreams.append(Restaurant(restaurant:restaraunt,blackAndWhite:false))
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
