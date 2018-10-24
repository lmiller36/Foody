/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A struct that persists a history of ice creams to `UserDefaults`.
*/

import Foundation

struct IceCreamHistory {

    // MARK: Properties
    
    private static let maximumHistorySize = 50

    private static let userDefaultsKey = "iceCreams"
    
    /// An array of previously created `IceCream`s.
    fileprivate var iceCreams: [RestaurantIcon]

    var count: Int {
        return iceCreams.count
    }

    subscript(index: Int) -> RestaurantIcon {
        return iceCreams[index]
    }
    
    // MARK: Initialization
    
    /// `IceCreamHistory`'s initializer is marked as private. Instead instances should be loaded via the `load` method.
    private init(iceCreams: [RestaurantIcon]) {
        self.iceCreams = iceCreams
    }

    /// Loads previously created `IceCream`s and returns a `IceCreamHistory` instance.
    static func load() -> IceCreamHistory {
        var iceCreams = [RestaurantIcon]()
        let defaults = UserDefaults.standard
//        iceCreams.append(IceCream(base: .burger, scoops: .scoops01, topping: .topping01))
//
//        let defaults = UserDefaults.standard
//
   
//
        // If no ice creams have been loaded, create some tasty examples.
//        if !iceCreams.isEmpty{
//            if let savedIceCreams = defaults.object(forKey: IceCreamHistory.userDefaultsKey) as? [String] {
//                iceCreams = savedIceCreams.compactMap { urlString in
//                    guard let url = URL(string: urlString) else { return nil }
//                    guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
//                    guard let queryItems = components.queryItems else { return nil }
//
//                    return RestaurantIcon(queryItems: queryItems)
//                }
//                print("SAVED ICE CREAMS")
//                print(iceCreams)
//
//            }
//            print("SAVED")
//            print(iceCreams)
//        }
////
 return IceCreamHistory(iceCreams: iceCreams)
        
    }
    
    /// Saves the history.
//
//    func save() {
//        // Save a maximum number ice creams.
//        let iceCreamsToSave = iceCreams.suffix(IceCreamHistory.maximumHistorySize)
//        
//        // Map the ice creams to an array of URL strings.
//        let iceCreamURLStrings: [String] = iceCreamsToSave.compactMap { iceCream in
//            var components = URLComponents()
//            components.queryItems = iceCream.queryItems
//            return components.url?.absoluteString
//        }
//        
//        let defaults = UserDefaults.standard
//        defaults.set(iceCreamURLStrings as AnyObject, forKey: IceCreamHistory.userDefaultsKey)
//
//    }
//    
//    mutating func append(_ iceCream: RestaurantIcon) {
//        // Ensure that no duplicates are inserted into the history
//        var newIceCreams = self.iceCreams.filter { $0 != iceCream }
//        newIceCreams.append(iceCream)
//        iceCreams = newIceCreams
//    }

}

/// Extends `IceCreamHistory` to conform to the `Sequence` protocol so it can be used in for..in statements.

extension IceCreamHistory: Sequence {

    typealias Iterator = AnyIterator<RestaurantIcon>
    
    func makeIterator() -> Iterator {
        var index = 0
        
        return Iterator {
            guard index < self.iceCreams.count else { return nil }
            
            let iceCream = self.iceCreams[index]
            index += 1
            
            return iceCream
        }
    }
    
}
