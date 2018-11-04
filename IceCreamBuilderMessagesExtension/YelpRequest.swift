//
//  YelpRequest.swift
//  IceCreamBuilder
//
//  Created by Lorne on 9/21/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import CoreLocation
func getNearby(coordinates:CLLocationCoordinate2D,callback: @escaping (_ businesses: [RestaurantInfo]) -> Void){
    
    let location = "?limit=50&latitude="+String(coordinates.latitude)+"&longitude="+String(coordinates.longitude) + "&radius="+String(CurrentLocation.sharedInstance.getRadius())
    // let location = "?limit=50&latitude=37.77943&longitude=-122.41404"
    print(location)
    
    let urlString = "https://api.yelp.com/v3/businesses/search"+location
    var sampleUsersRequest = URLRequest(url: URL(string:urlString)!)
    
    sampleUsersRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    sampleUsersRequest.addValue("Bearer 81A2OQtnPChp43pVdZ3HsVlScOg53SJcj7KrpPmDlqq6sXkBHodJC8vyFF6ztFAoPao5Fh5gi-zaGiho5ugHCiJr9M6h8J00xryMagRvfODuujLuf2POomR-dv6bW3Yx    ", forHTTPHeaderField: "Authorization")
    
    URLSession.shared.dataTask(with: sampleUsersRequest) { (data, response, error) in
        if error != nil {
            print(error!.localizedDescription)
        }
        
        guard let data = data else { return }
        
        let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        print(string)
        guard let businesses = try? JSONDecoder().decode(Businesses.self, from: data) else {
            print("Error: Couldn't decode data into businesses because of \(error)")
            return
        }
        
//        var restaurants = [RestaurantInfo]()
//
//        for restaurant in businesses{
//            if let restaurantValue = restaurant.value {
//                restaurants.append(restaurantValue)
//            }
//        }
        
        callback(businesses.getRestaurants())
        
        
        }.resume()
}
