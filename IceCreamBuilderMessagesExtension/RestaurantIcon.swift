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

    
    var restaurantInfo:RestaurantInfo?
    
    var blackAndWhite:Bool


}

/// Extends `IceCream` to be able to be represented by and created with an array of `NSURLQueryItem`s.
extension Restaurant {
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
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
