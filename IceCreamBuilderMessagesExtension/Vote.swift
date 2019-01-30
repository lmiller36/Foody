//
//  Vote.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by user on 1/3/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

//TODO: Fix
/// Sending format of data in messages
///
/// *Parameters*:
/// - **state**: The current AppState of the survey.
/// - **leader**: Leader's UUID string. *Only leader know if this is accurate*
/// - **messageSender**: Sender's UUID string
/// - **surveyID**: Survey's alphanumeric ID
/// - **urlQueryString**: URL to query Yelp API
/// - **vote1**: The user's *first* vote.
/// - **vote2**: The user's *second* vote.
/// - **vote3**: The user's *third* vote.
struct MessageStruct : Codable {
    
    //Cloudkit RecordID of the survey at hand
    let surveyID : String
    
//    let state : String
//    let leader: String
//    let messageSender: String
//    let surveyID : String
//    let urlQueryString : String?
//
//    let vote1 : Vote
//    let vote2 : Vote
//    let vote3 : Vote
    
}

/// A given vote on a dining option
///
/// *Parameters*:
/// - **cuisine**: Cuisine type of the vote
/// - **restaurantId**: Restaurant's Yelp id. *Only used in round 2*
/// - **approved**: A boolean if the user approves of the given dining option
/// - **ranking**: Leader's determined status of the dining option
struct Vote : Codable {

    let cuisine : String
    let restaurantId : String?
    let approved : Bool
    let ranking : Int
    
    enum CodingKeys : String,CodingKey{
        case cuisine
        case restaurantId
        case approved
        case ranking
    }
}

/// A given vote on a dining option
///
/// *Parameters*:
/// - **approvedBy**: A boolean if the user approves of the given dining option
/// - **ranking**: Leader's determined status of the dining option
struct Vote2 : Codable {
    
    let name : String
    let voteBy: String
    let approved:Bool
    
    enum CodingKeys : String,CodingKey{
        
        case name
        case voteBy
        case approved
    }
}

struct Votes : Codable {
    let votes : [Vote]
}
