//
//  Restaraunt.swift
//  IceCreamBuilder
//
//  Created by Lorne on 9/21/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

struct Businesses:Codable{
    let businesses:[Safe<RestaurantInfo>]
}

extension Businesses {
    func getRestaurants()->[RestaurantInfo]{
        var restaurants = [RestaurantInfo]()
        
        for restaurant in self.businesses{
            if let restaurantValue = restaurant.value {
                restaurants.append(restaurantValue)
            }
        }
        return restaurants
    }
}

public struct Safe<Base: Decodable>: Codable {
    let value: RestaurantInfo?
    
    public init(from decoder: Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()
            print(container)
            self.value = try container.decode(RestaurantInfo.self)
        } catch {
            assertionFailure("ERROR: \(error)")
            // TODO: automatically send a report about a corrupted data
            self.value = nil
        }
    }
}

//extension Businesses: Sequence {
//    
//    typealias Iterator = AnyIterator<RestaurantInfo>
//    
//    func makeIterator() -> Iterator {
//        var index = 0
//        
//        return Iterator {
//            guard index < self.businesses.count else { return nil }
//            
//            let restaraunt = self.businesses[index]
//            index += 1
//            
//            return restaraunt
//        }
//    }
//}

//#TODO combine into one class with RestaurantIcon
struct RestaurantInfo: Codable {
    let id: String
    let alias: String
    let name:String
    let imageUrl: String
    let isClosed:Bool
    let url: String
    let reviewCount:Int
    let categories: [Category]
    let rating: Double
    let coordinates:Coordinates
    let transactions:[String]
    let price:String?
    let location:Location
    let phone:String
    let displayPhone:String
    let distance:Double
    
    enum CodingKeys : String, CodingKey {
        case id
        case alias
        case name
        case imageUrl = "image_url"
        case isClosed = "is_closed"
        case url
        case reviewCount="review_count"
        case categories
        case rating
        case coordinates
        case transactions
        case price
        case location
        case phone
        case displayPhone = "display_phone"
        case distance
        
        
    }
    
}

struct Category:Codable{
    let alias:String
    let title:String
}

struct Location:Codable{
    let address1    : String?
    let address2    : String?
    let address3    : String?
    let city    :    String
    let zipCode    :    String
    let country    :    String
    let state    :    String
    let displayAddress : [String]
    enum CodingKeys : String, CodingKey {
        case address1
        case address2
        case address3
        case city
        case zipCode="zip_code"
        case country
        case state
        case displayAddress = "display_address"
    }
}

struct Coordinates:Codable{
    let latitude: Double
    let longitude: Double
    
}

extension Array where Element: Equatable {
    public mutating func mergeElements<C : Collection>(newElements: C) where C.Iterator.Element == Element{
        let filteredList = newElements.filter({!self.contains($0)})
        self.append(contentsOf: filteredList)
    }
}

extension RestaurantInfo: Equatable {}

func ==(lhs: RestaurantInfo, rhs: RestaurantInfo) -> Bool {
    return lhs.id == rhs.id
}
