//
//  Vote.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by user on 1/3/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct MessageStruct : Codable {
    
    let state : String
    let leader: String
    let messageSender: String
    let surveyID : String
    
    let vote1 : Vote
    let vote2 : Vote
    let vote3 : Vote
    
}

struct Vote : Codable {
    let category : String
    let restaurantId : String?
    let approved : Bool
    let ranking : Int
    
    enum CodingKeys : String,CodingKey{
        case category
        case restaurantId
        case approved
        case ranking
    }
}
