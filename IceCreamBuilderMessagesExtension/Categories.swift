//
//  Categories.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by user on 12/26/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

class RestaurantGroup {
    let applicableRestaurants : [Icon]
    let displayIcon : Icon
    let grouping : Grouping
    
    init(applicationRestaurants:[Icon],displayIcon:Icon,grouping:Grouping) {
        self.applicableRestaurants = applicationRestaurants
        self.displayIcon = displayIcon
        self.grouping = grouping
    }
}

enum Grouping : String {
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

class Categories {
    
    static let sharedInstance = Categories.init()
    
    var allRestaurauntGroups: [Grouping : RestaurantGroup]
    var hiddenRestaurantGroups : [Grouping : RestaurantGroup]
    var currentOrdering : [Grouping]
    let allGroupings = [Grouping.American,Grouping.Breakfast,Grouping.Asian,Grouping.Japanese,Grouping.Chinese,Grouping.Italian,Grouping.Pizza,Grouping.Mexican,Grouping.Burgers]
    
    init(){
        self.allRestaurauntGroups = Categories.populateIcons()
        self.hiddenRestaurantGroups = [Grouping : RestaurantGroup]()
        self.currentOrdering = allGroupings.shuffled()
    }
  
    func setCategories(categories:[String]){
        let givenCategories = categories.map{Grouping.init(rawValue: $0)}
        
        currentOrdering = givenCategories as! [Grouping]
    }
    
    func getVisibleIcons() -> [Icon] {
        return self.currentOrdering.map{(self.allRestaurauntGroups[$0]?.displayIcon)!}
    }
    
    func getAvailableRestaurauntGroupsCount() -> Int {
        return self.currentOrdering.count
    }
    
    func getRestaurantGroup(index:Int) -> RestaurantGroup{
        let key = self.currentOrdering[index]
        
        return self.allRestaurauntGroups[key]!
        
    }
    
    func shuffle(){
        self.currentOrdering = allGroupings.shuffled()
    }
    
    
//    func removeItem(groupingToRemove:Grouping) -> RestaurantGroup{
//        let removedGroup = availableRestaurauntGroups.removeValue(forKey: groupingToRemove)
//        hiddenRestaurantGroups [groupingToRemove] = removedGroup
//        return removedGroup!
//    }
    
    func removeItem(index:Int) -> RestaurantGroup
    {
        let groupingToRemove = self.currentOrdering.remove(at: index)
        return self.allRestaurauntGroups[groupingToRemove]!
    }
    
    static func populateIcons() -> [Grouping : RestaurantGroup]{
        
        var restaurantGroups = [Grouping : RestaurantGroup]()
        
        restaurantGroups[Grouping.American] = RestaurantGroup.init(applicationRestaurants: [.american,.burgers,.sandwiches], displayIcon: .american,grouping:Grouping.American)
        
        
        restaurantGroups[Grouping.Breakfast] = RestaurantGroup.init(applicationRestaurants: [.bagels,.bakery,.breakfastBrunch,.sandwiches], displayIcon: .breakfastBrunch,grouping: Grouping.Breakfast)
        
        restaurantGroups[Grouping.Asian] = RestaurantGroup.init(applicationRestaurants: [.asianfusion,.korean,.ramen,.thai, .chinese,.bento, .japanese, .sushi], displayIcon: .asianfusion,grouping: Grouping.Asian)
        
        restaurantGroups[Grouping.Japanese] = RestaurantGroup.init(applicationRestaurants: [.japanese,.sushi], displayIcon: .japanese, grouping: Grouping.Japanese)
        
        
        restaurantGroups[Grouping.Chinese] = RestaurantGroup.init(applicationRestaurants: [.chinese], displayIcon: .chinese, grouping: Grouping.Chinese)
        
        restaurantGroups[Grouping.Italian] = RestaurantGroup.init(applicationRestaurants: [.italian], displayIcon: .italian, grouping: Grouping.Italian)
        
        restaurantGroups[Grouping.Pizza] = RestaurantGroup.init(applicationRestaurants: [.pizza], displayIcon: .pizza, grouping: Grouping.Pizza)
        
        restaurantGroups[Grouping.Mexican] = RestaurantGroup.init(applicationRestaurants: [.mexican], displayIcon: .mexican, grouping: Grouping.Mexican)
        
        restaurantGroups[Grouping.Burgers] = RestaurantGroup.init(applicationRestaurants: [.burger,.burgers], displayIcon: .burger, grouping: Grouping.Burgers)
        
        
        //let restaurantGroups = [American,Breakfast,Asian,Japanese,Chinese,Italian,Pizza,Mexican,Burgers]
        
        return restaurantGroups
    }
    
    //    func mapCategories(type:Icon)->Int{
    //        switch type{
    //        case .american:
    //            return 10
    //        case .asianfusion,.bento, .chinese,.thai:
    //            return 3
    //        case .bagels:
    //            return 5
    //        case .bakery:
    //            return 5
    //        case .bars:
    //            return 4
    //        case .bbq:
    //            return 10
    //        case .brazilian:
    //            return 6
    //        case .breakfastBrunch:
    //            return 7
    //        case .burgers:
    //            return 12
    //        case .czech:
    //            return 4
    //        case .cheese:
    //            return 8
    //        case .chickenwings:
    //            return 5
    //        case .cocktailBars:
    //            return 6
    //        case .coffee:
    //            return 5
    //        case .cuban:
    //            return 8
    //        case .deli:
    //            return 6
    //        case .desserts:
    //            return 5
    //        case .donuts:
    //            return 3
    //        case .falafel:
    //            return 6
    //        case .foodstand:
    //            return 7
    //        case .fishnchips:
    //            return 6
    //        case .french:
    //            return 9
    //        case .german:
    //            return 7
    //        case .gourmet:
    //            return 5
    //        case .greek:
    //            return 10
    //        case .hawaiian:
    //            return 5
    //        case .hotdog:
    //            return 5
    //        case .icecream:
    //            return 5
    //        case .italian:
    //            return 12
    //        case .japanese:
    //            return 12
    //        case .jazz:
    //            return 5
    //        case .korean:
    //            return 5
    //        case .mexican:
    //            return 12
    //        case .mediterranean:
    //            return 4
    //        case .pizza:
    //            return 12
    //        case .ramen:
    //            return 7
    //        case .russian:
    //            return 6
    //        case .seafood:
    //            return 12
    //        case .spanish:
    //            return 5
    //        case .steak:
    //            return 6
    //        case .sushi:
    //            return 12
    //        case .tapas:
    //            return 6
    //        case .tea:
    //            return 3
    //        case .vegetarian:
    //            return 2
    //        case .winebars:
    //            return 2
    //        case .chickenshop:
    //            return 2
    //        case .sandwiches:
    //            return 6
    //        case .burger:
    //            <#code#>
    //        case .base01:
    //            <#code#>
    //        }
    //
    //        func getWeight(type:Icon)->Int{
    //            switch type{
    //            case .american:
    //                return 10
    //            case .asianfusion:
    //                return 3
    //            case .bagels:
    //                return 5
    //            case .bakery:
    //                return 5
    //            case .bars:
    //                return 4
    //            case .bbq:
    //                return 10
    //            case .bento:
    //                return 5
    //            case .brazilian:
    //                return 6
    //            case .breakfastBrunch:
    //                return 7
    //            case .burgers:
    //                return 12
    //            case .czech:
    //                return 4
    //            case .cheese:
    //                return 8
    //            case .chickenwings:
    //                return 5
    //            case .cocktailBars:
    //                return 6
    //            case .coffee:
    //                return 5
    //            case .cuban:
    //                return 8
    //            case .deli:
    //                return 6
    //            case .desserts:
    //                return 5
    //            case .donuts:
    //                return 3
    //            case .falafel:
    //                return 6
    //            case .foodstand:
    //                return 7
    //            case .fishnchips:
    //                return 6
    //            case .french:
    //                return 9
    //            case .german:
    //                return 7
    //            case .gourmet:
    //                return 5
    //            case .greek:
    //                return 10
    //            case .hawaiian:
    //                return 5
    //            case .hotdog:
    //                return 5
    //            case .icecream:
    //                return 5
    //            case .italian:
    //                return 12
    //            case .japanese:
    //                return 12
    //            case .jazz:
    //                return 5
    //            case .korean:
    //                return 5
    //            case .mexican:
    //                return 12
    //            case .mediterranean:
    //                return 4
    //            case .pizza:
    //                return 12
    //            case .ramen:
    //                return 7
    //            case .russian:
    //                return 6
    //            case .seafood:
    //                return 12
    //            case .spanish:
    //                return 5
    //            case .steak:
    //                return 6
    //            case .sushi:
    //                return 12
    //            case .tapas:
    //                return 6
    //            case .tea:
    //                return 3
    //            case .thai:
    //                return 12
    //            case .vegetarian:
    //                return 2
    //            case .winebars:
    //                return 2
    //            case .chickenshop:
    //                return 2
    //            case .sandwiches:
    //                return 6
    //            case .chinese:
    //                return 12
    //
    //            default:
    //                print(type)
    //                return 0
    //            }
    //        }
    
    //    func getRandomizedCatgories()->[Icon]{
    //        var icons = [Icon]()
    //
    //        var weights = [Icon:Int]()
    //
    //        weights[Icon.american] = 10
    //        weights[Icon.asianfusion] = 10
    //        weights[Icon.bagels] = 10
    //        weights[Icon.bakery] = 10
    //        weights[Icon.bars] = 10
    //        weights[Icon.bbq] = 10
    //        weights[Icon.bento] = 10
    //        weights[Icon.brazilian] = 10
    //        weights[Icon.breakfastBrunch] = 10
    //        weights[Icon.burgers] = 10
    //        weights[Icon.cheese] = 10
    //        weights[Icon.chickenshop] = 10
    //        weights[Icon.chickenwings] = 10
    //        weights[Icon.chinese] = 10
    //        weights[Icon.cocktailBars] = 10
    //        weights[Icon.coffee] = 10
    //        weights[Icon.cuban] = 10
    //        weights[Icon.czech] = 10
    //        weights[Icon.deli] = 10
    //        weights[Icon.] = 10
    //        weights[Icon.bento] = 10
    //        weights[Icon.brazilian] = 10
    //        weights[Icon.breakfastBrunch] = 10
    //        weights[Icon.burgers] = 10
    //        weights[Icon.cheese] = 10
    //        weights[Icon.chickenshop] = 10
    //        weights[Icon.chickenwings] = 10
    //        weights[Icon.chinese] = 10
    //        return icons
    //    }
}


