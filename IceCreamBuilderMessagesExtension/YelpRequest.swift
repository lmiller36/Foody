//
//  YelpRequest.swift
//  IceCreamBuilder
//
//  Created by Lorne on 9/21/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import CoreLocation

public class YelpKeyword {
    let parameter : YelpParameter
    let data : String
    
    //TODO: Do class init
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    init(keyword: YelpParameter, data:String) {
        self.parameter = keyword
        self.data = data
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    func getQueryLine() -> String {
        return self.parameter.rawValue + "=" + data
    }
}

//TODO: header
public enum YelpParameter : String {
    case limit
    case radius
    case categories
    case latitude
    case longitude
    case sort_by
}

//TODO: header
public struct YelpRequest {
    
    let coordinates : CLLocationCoordinate2D
    let result_limit : Int
    let radius_in_meters : Int
    let categories : [String]
    let sortAttribute : SortAttribute
    
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    fileprivate func generateQueryList() -> [YelpKeyword] {
        let latitude = YelpKeyword.init(keyword: YelpParameter.latitude, data: String(self.coordinates.latitude))
        
        let longitude = YelpKeyword.init(keyword: YelpParameter.longitude, data: String(self.coordinates.longitude))
        
        let radius = YelpKeyword.init(keyword: YelpParameter.radius, data: String(self.radius_in_meters))
        
        let limit = YelpKeyword.init(keyword: YelpParameter.limit, data: String(50))
        
        let comma_separated_list = self.categories.joined(separator:",").lowercased()
        let categories = YelpKeyword.init(keyword: YelpParameter.categories, data: comma_separated_list)

        let sortBy = YelpKeyword.init(keyword: YelpParameter.sort_by, data: self.sortAttribute.rawValue)
        
        let query: [YelpKeyword] = [latitude,longitude,limit,categories,sortBy]
        return query
    }
    
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    func request_url() -> String {
        let base_url = "https://api.yelp.com/v3/businesses/search"
        
        //query parameters
        let queryList = self.generateQueryList()
        let query_string =  "?" + queryList.compactMap { $0.getQueryLine() }.joined(separator:"&")
        
        let url = base_url + query_string
        
        return url
    }
}

//TODO: Do class init
/**
 Initializes a new bicycle with the provided parts and specifications.
 
 Description is something you might want
 
 - Throws: SomeError you might want to catch
 
 - parameter radius: The frame size of the bicycle, in centimeters
 
 - Returns: A beautiful, brand-new bicycle, custom-built just for you.
 */
func getNearbyRestaurants(base_url : String,callback: @escaping (_ restaurants: [RestaurantInfo]) -> Void){
        // TODO: Add error check if url is invalid for a yelp request
        guard let url = URL(string:base_url) else {fatalError("URL not valid")}
        var userRequest = URLRequest(url: url)
        
        //content type
        userRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //bearer token for authorization
        userRequest.addValue("Bearer 81A2OQtnPChp43pVdZ3HsVlScOg53SJcj7KrpPmDlqq6sXkBHodJC8vyFF6ztFAoPao5Fh5gi-zaGiho5ugHCiJr9M6h8J00xryMagRvfODuujLuf2POomR-dv6bW3Yx", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: userRequest) { (data, response, error) in
            if error != nil {
                fatalError("Error occurred")
            }
            
            guard let data = data else { return }
            
            let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            
            guard let businesses = try? JSONDecoder().decode(Businesses.self, from: data) else {
               fatalError("Error occurred")
            }
            
            callback(businesses.getRestaurants())
            
            
            }.resume()
}

public enum SortAttribute : String{
    case best_match
    case rating
    case review_count
    case distance
}

//TODO: Do class init
/**
 Initializes a new bicycle with the provided parts and specifications.
 
 Description is something you might want
 
 - Throws: SomeError you might want to catch
 
 - parameter radius: The frame size of the bicycle, in centimeters
 
 - Returns: A beautiful, brand-new bicycle, custom-built just for you.
 */
func getType(type:String)->Icon {
    switch type{
    case "newamerican":
        return .american
    case "asianfusion":
        return .asianfusion
    case "tradamerican":
        return .american
    case "bagels":
        return .bagels
    case "bakeries":
        return .bakery
    case "bars":
        return .bars
    case "bbq":
        return .bbq
    case "japacurry":
        return .bento
    case "brazilian":
        return .brazilian
    case "breakfast_brunch":
        return .breakfastBrunch
    case "burgers":
        return .burgers
    case "czech":
        return .czech
    case "cheese":
        return .cheese
    case "chicken_wings":
        return .chickenwings
    case "cocktailbars":
        return .cocktailBars
    case "coffee":
        return .coffee
    case "cafes":
        return .coffee
    case "cuban":
        return .cuban
    case "deli":
        return .deli
    case "delis":
        return .deli
    case "desserts":
        return .desserts
    case "donuts":
        return .donuts
    case "falafel":
        return .falafel
    case "foodstands":
        return .foodstand
    case "foodtrucks":
        return .foodstand
    case "fishnchips":
        return .fishnchips
    case "french":
        return .french
    case "german":
        return .german
    case "gourmet":
        return .gourmet
    case "greek":
        return .greek
    case "hawaiian":
        return .hawaiian
    case "hotdog":
        return .hotdog
    case "icecream":
        return .icecream
    case "italian":
        return .italian
    case "japanese":
        return .japanese
    case "jazzandblues":
        return .jazz
    case "korean":
        return .korean
    case "tacos":
        return .mexican
    case "mediterranean":
        return .mediterranean
    case "mexican":
        return .mexican
    case "pizza":
        return .pizza
    case "ramen":
        return .ramen
    case "russian":
        return .russian
    case "seafood":
        return .seafood
    case "latin":
        return .spanish
    case "spanish":
        return .spanish
    case "steak":
        return .steak
    case "sushi":
        return .sushi
    case "tapas":
        return .tapas
    case "tapasmallplates":
        return .tapas
    case "tea":
        return .tea
    case "thai":
        return .thai
    case "vietnamese":
        return .thai
    case "vegan":
        return .vegetarian
    case "wine_bars":
        return .winebars
    case "chickenshop":
        return .chickenshop
    case "sandwiches":
        return .sandwiches
    case "chinese":
        return .chinese
        
    default:
        return .american
    }
}
