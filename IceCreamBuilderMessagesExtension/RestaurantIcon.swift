/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Defines the `IceCream` struct that represents a complete or partially built ice cream.
*/

import Foundation
import Messages

struct RestaurantIcon {

    // MARK: Properties
    
    var icon: Icon?
//
//    var scoops: Scoops?
//
//    var topping: Topping?
    
    var restaraunt:Restaurant?
    
    var blackAndWhite:Bool

    
//    var isComplete: Bool {
//        return base != nil && scoops != nil && topping != nil
//    }
}

/// Extends `IceCream` to be able to be represented by and created with an array of `NSURLQueryItem`s.
extension RestaurantIcon {
    
    // MARK: Computed properties
    
    /// - Tag: QueryItems
//    var queryItems: [URLQueryItem] {
//        var items = [URLQueryItem]()
//
//        if let part = base {
//            items.append(part.queryItem)
//        }
//        if let part = scoops {
//            items.append(part.queryItem)
//        }
//        if let part = topping {
//            items.append(part.queryItem)
//        }
//
//        return items
//    }
    
    // MARK: Initialization
    
//    init?(queryItems: [URLQueryItem]) {
//        var base: Base?
//        var scoops: Scoops?
//        var topping: Topping?
//
//
//
//        for queryItem in queryItems {
//            guard let value = queryItem.value else { continue }
//
//            if let decodedPart = Base(rawValue: value), queryItem.name == Base.queryItemKey {
//                base = decodedPart
//            }
//            if let decodedPart = Scoops(rawValue: value), queryItem.name == Scoops.queryItemKey {
//                scoops = decodedPart
//            }
//            if let decodedPart = Topping(rawValue: value), queryItem.name == Topping.queryItemKey {
//                topping = decodedPart
//            }
//
//
//        }
//
//
//        guard let decodedBase = base else { return nil }
//
//        self.base = decodedBase
//        self.scoops = scoops
//        self.topping = topping
//        self.blackAndWhite = false
//    }
    
    
    init(restaurant:Restaurant,blackAndWhite:Bool){
//        self.base = iceCream.base
//        self.scoops = iceCream.scoops
//        self.topping = iceCream.topping
        self.restaraunt = restaurant
        self.blackAndWhite = blackAndWhite
        self.icon = getType(type: restaurant.categories[0].alias)
    }
    
    init(icon:Icon,blackAndWhite:Bool){
        //        self.base = iceCream.base
        //        self.scoops = iceCream.scoops
        //        self.topping = iceCream.topping
        self.restaraunt = Optional<Restaurant>.none
        self.icon = icon
        self.blackAndWhite = blackAndWhite
    }
    
    func getImage()->Icon? {
    
        //check if restaurant is available
//        guard let restaurant = self.restaraunt else {
//            guard let icon = self.icon else {return Optional<Icon>.none}
//            return icon
//        }
    return icon
//    mutating func toggleBlackAndWhite(){
//        let currentStatus = self.blackAndWhite
//        self.blackAndWhite = !currentStatus
//    }
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
