//
//  CuisineType.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by user on 1/3/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation


//Used by leader
class Cuisine {
    let applicableCategories : [Icon]
    let displayInformation : DiningOption
    
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    
    init(applicationRestaurants:[Icon],displayIcon:Icon,grouping:Grouping) {
        self.applicableCategories = applicationRestaurants
        self.displayInformation = DiningOption.init(cuisine: grouping.rawValue, image: displayIcon.image, restaurant: Optional<RestaurantInfo>.none)
    }
}

class Cuisines {
    
    static let sharedInstance = Cuisines.init()
    
    var hiddenRestaurantGroups : [Grouping : Cuisine]
    var currentOrdering : [Grouping]
    
    let allGroupings = [Grouping.American,Grouping.Breakfast,Grouping.Asian,Grouping.Japanese,Grouping.Chinese,Grouping.Italian,Grouping.Pizza,Grouping.Mexican,Grouping.Burgers]
    
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    fileprivate init(){
        //self.cuisineMap = Cuisines.cuisineMappings()
        self.hiddenRestaurantGroups = [Grouping : Cuisine]()
        self.currentOrdering = allGroupings.shuffled()
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    func setCategories(categories:[String]){
        let givenCategories = categories.map{Grouping.init(rawValue: $0)}
        currentOrdering = givenCategories as! [Grouping]
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    func getAvailableRestaurauntGroupsCount() -> Int {
        return self.currentOrdering.count
    }
    
    func getRestaurantGroup(index:Int) -> DiningOption{
        let grouping = self.currentOrdering[index]
        let cuisine = Cuisines.getCuisine(grouping: grouping)
        return cuisine.displayInformation
        
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    func shuffle(){
        self.currentOrdering = allGroupings.shuffled()
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    func removeItem(index:Int) -> DiningOption
    {
        let groupingToRemove = self.currentOrdering.remove(at: index)
        let removedItem = Cuisines.getCuisine(grouping: groupingToRemove)
        
        return removedItem.displayInformation
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */    static func getCuisine(grouping:Grouping) -> Cuisine{
        
        
        switch (grouping){
            
        case .American:
            return Cuisine.init(applicationRestaurants: [.american,.burgers,.sandwiches], displayIcon: .american,grouping:Grouping.American)
        case .Breakfast:
            return Cuisine.init(applicationRestaurants: [.bagels,.bakery,.breakfastBrunch,.sandwiches], displayIcon: .breakfastBrunch,grouping: Grouping.Breakfast)
        case .Asian:
            return Cuisine.init(applicationRestaurants: [.asianfusion,.korean,.ramen,.thai, .chinese,.bento, .japanese, .sushi], displayIcon: .asianfusion,grouping: Grouping.Asian)
        case .Japanese:
            return Cuisine.init(applicationRestaurants: [.japanese,.sushi], displayIcon: .japanese, grouping: Grouping.Japanese)
        case .Chinese:
            return Cuisine.init(applicationRestaurants: [.chinese], displayIcon: .chinese, grouping: Grouping.Chinese)
        case .Italian:
            return Cuisine.init(applicationRestaurants: [.italian], displayIcon: .italian, grouping: Grouping.Italian)
        case .Pizza:
            return Cuisine.init(applicationRestaurants: [.pizza], displayIcon: .pizza, grouping: Grouping.Pizza)
        case .Mexican:
            return Cuisine.init(applicationRestaurants: [.mexican], displayIcon: .mexican, grouping: Grouping.Mexican)
        case .Burgers:
            return Cuisine.init(applicationRestaurants: [.burger,.burgers], displayIcon: .burger, grouping: Grouping.Burgers)
            
        }
    }
    
}

//TODO: header
public enum Grouping : String,CodingKey {
    case American
    case Breakfast
    case Asian
    case Japanese
    case Chinese
    case Italian
    case Pizza
    case Mexican
    case Burgers
}
