//
//  Categories.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by user on 12/26/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

class Categories {
    
    static let sharedInstance = Categories.init()
    
    var availableIcons : [Icon]
    
    init(){
       // self.availableIcons = [Icon]()
        
        //populate categories
        
//        var count = 0
//        var startIndex = [Icon : Int]()
//        var endIndex = [Icon : Int]()
//
//        for icon in Icon.all {
//            let weight = getWeight(type: icon)
//            let endIndexCount = count + weight - 1
//
//            startIndex[icon] = count
//            endIndex[icon] = endIndexCount
//
//        }
        
        self.availableIcons = Icon.all
    }
    
    func getFilteredTypes() -> [Icon] {
        return availableIcons
    }
    
    func getFilteredTypesCount() -> Int {
        return availableIcons.count
    }
    
    func removeItem(index:Int) -> Icon{
        return availableIcons.remove(at:index)
    }
    
    func getWeight(type:Icon)->Int{
        switch type{
        case .american:
            return 10
        case .asianfusion:
            return 3
        case .bagels:
            return 5
        case .bakery:
            return 5
        case .bars:
            return 4
        case .bbq:
            return 10
        case .bento:
            return 5
        case .brazilian:
            return 6
        case .breakfastBrunch:
            return 7
        case .burgers:
            return 12
        case .czech:
            return 4
        case .cheese:
            return 8
        case .chickenwings:
            return 5
        case .cocktailBars:
            return 6
        case .coffee:
            return 5
        case .cuban:
            return 8
        case .deli:
            return 6
        case .desserts:
            return 5
        case .donuts:
            return 3
        case .falafel:
            return 6
        case .foodstand:
            return 7
        case .fishnchips:
            return 6
        case .french:
            return 9
        case .german:
            return 7
        case .gourmet:
            return 5
        case .greek:
            return 10
        case .hawaiian:
            return 5
        case .hotdog:
            return 5
        case .icecream:
            return 5
        case .italian:
            return 12
        case .japanese:
            return 12
        case .jazz:
            return 5
        case .korean:
            return 5
        case .mexican:
            return 12
        case .mediterranean:
            return 4
        case .pizza:
            return 12
        case .ramen:
            return 7
        case .russian:
            return 6
        case .seafood:
            return 12
        case .spanish:
            return 5
        case .steak:
            return 6
        case .sushi:
            return 12
        case .tapas:
            return 6
        case .tea:
            return 3
        case .thai:
            return 12
        case .vegetarian:
            return 2
        case .winebars:
            return 2
        case .chickenshop:
            return 2
        case .sandwiches:
            return 6
        case .chinese:
            return 12
            
        default:
            print(type)
            return 0
        }
    }
    
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


