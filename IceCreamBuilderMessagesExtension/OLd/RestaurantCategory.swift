//
//  RestaurantCategory.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by lorne on 11/1/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

class RestaurantCategory :Equatable,Hashable {
    let key: String
    let displayName:String
    let ranking = 1
    
    var hashValue: Int {
        return self.key.hashValue
    }
    
    init(key:String,displayName:String){
        self.key = key
        self.displayName = displayName
    }
    
    func equalTo(rhs: RestaurantCategory) -> Bool {
        return self.key == rhs.key
    }
    
   
}

func ==(lhs: RestaurantCategory, rhs: RestaurantCategory) -> Bool {
    return lhs.equalTo(rhs: rhs)
}

