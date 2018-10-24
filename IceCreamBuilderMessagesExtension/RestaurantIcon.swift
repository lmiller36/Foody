/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Defines the `IceCream` struct that represents a complete or partially built ice cream.
*/

import Foundation
import Messages

struct Restaurant {

    // MARK: Properties
    
    var icon: Icon?
//
//    var scoops: Scoops?
//
//    var topping: Topping?
    
    var restaurantInfo:RestaurantInfo?
    
    var blackAndWhite:Bool

    
//    var isComplete: Bool {
//        return base != nil && scoops != nil && topping != nil
//    }
}

/// Extends `IceCream` to be able to be represented by and created with an array of `NSURLQueryItem`s.
extension Restaurant {
    
    
    init(restaurant:RestaurantInfo,blackAndWhite:Bool){
        self.restaurantInfo = restaurant
        self.blackAndWhite = blackAndWhite
        self.icon = getType(type: restaurant.categories[0].alias)
    }
    
    init(icon:Icon,blackAndWhite:Bool){
        self.restaurantInfo = Optional<RestaurantInfo>.none
        self.icon = icon
        self.blackAndWhite = blackAndWhite
    }
    
    func getImage()->Icon? {
    return icon
    }
}

/// Extends `IceCream` to be able to be created with the contents of an `MSMessage`.

//extension RestaurantIcon {
//
//    // MARK: Initialization
//
//    init?(message: MSMessage?) {
//        guard let messageURL = message?.url else { return nil }
//        guard let urlComponents = NSURLComponents(url: messageURL, resolvingAgainstBaseURL: false) else { return nil }
//        guard let queryItems = urlComponents.queryItems else { return nil }
//        self.init(queryItems: queryItems)
//    }
//
//}

/// Extends `IceCream` to make it `Equatable`.
//extension RestaurantIcon: Equatable {}
//
//func ==(lhs: RestaurantIcon, rhs: RestaurantIcon) -> Bool {
//    return lhs.base == rhs.base && lhs.scoops == rhs.scoops && lhs.topping == rhs.topping
//}
