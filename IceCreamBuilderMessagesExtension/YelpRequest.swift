//
//  YelpRequest.swift
//  IceCreamBuilder
//
//  Created by Lorne on 9/21/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import CoreLocation

//class YelpRequest {
//    let baseURL =  "https://api.yelp.com/v3/businesses/search"
//}

public class YelpKeyword {
    let parameter : YelpParameter
    let data : String
    
    init(keyword: YelpParameter, data:String) {
        self.parameter = keyword
        self.data = data
    }
    
    func getQueryLine() -> String {
        return self.parameter.rawValue + "=" + data
    }
}

public enum YelpParameter : String {
    case limit
    case radius
    case categories
    case latitude
    case longitude
    case sort_by
}

public struct YelpRequest {
    
    let coordinates : CLLocationCoordinate2D
    let result_limit : Int
    let radius_in_meters : Int
    let categories : [String]
    let sortAttribute : SortAttribute
    
    fileprivate func generateQueryList() -> [YelpKeyword] {
        let latitude = YelpKeyword.init(keyword: YelpParameter.latitude, data: String(self.coordinates.latitude))
        
        let longitude = YelpKeyword.init(keyword: YelpParameter.longitude, data: String(self.coordinates.longitude))
        
        let radius = YelpKeyword.init(keyword: YelpParameter.radius, data: String(self.radius_in_meters))
        
        let limit = YelpKeyword.init(keyword: YelpParameter.limit, data: String(50))
        
        let comma_separated_list = self.categories.joined(separator:",").lowercased()
        print(comma_separated_list)
        let categories = YelpKeyword.init(keyword: YelpParameter.categories, data: comma_separated_list)

        let sortBy = YelpKeyword.init(keyword: YelpParameter.sort_by, data: self.sortAttribute.rawValue)
        
        let query: [YelpKeyword] = [latitude,longitude,limit,categories,sortBy]
        return query
    }
    
    func request_url() -> String {
        var base_url = "https://api.yelp.com/v3/businesses/search"
        
        //query parameters
        let queryList = self.generateQueryList()
        let query_string =  "?" + queryList.compactMap { $0.getQueryLine() }.joined(separator:"&")
        // append params
        
//        //set number of results to be returned
//        base_url = base_url.appendingFormat("?limit=" + String(result_limit))
//
//        //set radius of search
//        base_url = base_url.appendingFormat("&radius="+String(radius_in_meters))
//
//        //set categories
//        let comma_separated_list = categories.joined(separator:",").lowercased()
//        print(comma_separated_list)
//        base_url = base_url.appendingFormat("&categories="+comma_separated_list)
//
//        //set latitude and longitude
//        let latitude = String(coordinates.latitude)
//        let longitude = String(coordinates.longitude)
//        base_url = base_url.appendingFormat("&latitude="+latitude)
//        base_url = base_url.appendingFormat("&longitude="+longitude)
//
//        print(base_url)
        
        let url = base_url + query_string
        
        return url
    }
}
    
func getNearbyRestaurants(base_url : String,callback: @escaping (_ restaurants: [RestaurantInfo]) -> Void){
        
        
        
        guard let url = URL(string:base_url) else {fatalError("URL not valid")}
        var userRequest = URLRequest(url: url)
        
        //content type
        userRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //bearer token for authorization
        userRequest.addValue("Bearer 81A2OQtnPChp43pVdZ3HsVlScOg53SJcj7KrpPmDlqq6sXkBHodJC8vyFF6ztFAoPao5Fh5gi-zaGiho5ugHCiJr9M6h8J00xryMagRvfODuujLuf2POomR-dv6bW3Yx", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: userRequest) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            
            let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            
            guard let businesses = try? JSONDecoder().decode(Businesses.self, from: data) else {
                print("Error: Couldn't decode data into businesses because of \(error)")
                return
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
