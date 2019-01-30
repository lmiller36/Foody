//
//  Survey_Cloud.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by user on 1/29/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

import CloudKit

struct SurveyCloud : Codable{
    
    let leaderID : String
    let participantCount : Int
    let currentRound : String
    
    //first round
    let chosenCuisines : [String]
    let votesForEachCuisine : [String]
    let hasVotedInRoundOne : [String]
    
    //second round
    let chosenRestaurants : [String]
    let votesForEachRestaurant : [String]
    let hasVotedInRoundTwo : [String]
    
    //Winners
    let winningCuisineIndex : Int
    let winningRestaurantIndex : Int
    
    func getDict()->[String:CKRecordValue] {
        
        
        return ["leaderID": leaderID as __CKRecordObjCValue,
                "participantCount": participantCount as __CKRecordObjCValue,
                "currentRound": currentRound as __CKRecordObjCValue,
                
                "chosenCuisines": chosenCuisines as __CKRecordObjCValue,
                "votesForEachCuisine" : votesForEachCuisine as __CKRecordObjCValue,
            "hasVotedInRoundOne": hasVotedInRoundOne as __CKRecordObjCValue,
            
            "chosenRestaurants": chosenRestaurants as __CKRecordObjCValue,
            "votesForEachRestaurant" : votesForEachRestaurant as __CKRecordObjCValue,
            "hasVotedInRoundTwo": hasVotedInRoundTwo as __CKRecordObjCValue,
            
            "winningCuisineIndex": winningCuisineIndex as __CKRecordObjCValue,
            "winningRestaurantIndex": winningRestaurantIndex as __CKRecordObjCValue
            
        ]
    }
    
    //    func createRecordID(record:CKRecord) -> CKRecord{
    //
    //    }
    
//    func getChosenCuisine() -> String {
//        return self.chosenCuisines[self.winningCuisineIndex]
//    }
//
//    func getChosenRestaurant () ->RestaurantInfo {
//        return self.chosenRestaurants[self.winningRestaurantIndex]
//    }
    
    static func convertRecord(record:CKRecord) -> SurveyCloud{
        do {
            let leaderID = record["leaderID"] as! String
            let participantCount = record["participantCount"] as! Int
            let currentRound = record["currentRound"] as! String
            
            //first round
            let chosenCuisines = record["chosenCuisines"] as! [String]
            //                                    guard let decodedVotesForEachCuisine = storedJSON.data(using: .utf8) else {fatalError("Data could not be decoded")}
            //
            //                                    guard let decodedSurvey = try?JSONDecoder().decode(SurveyCloud.self, from: decodedData) else {fatalError("Data not sent as message struct")}
            let votesForEachCuisine_str = record["votesForEachCuisine"]  as! [String]
//            let votesForEachCuisine = votesForEachCuisine_str.map{
//                (vote) -> String in
//                let vote_str = vote as! String
//                guard let voteData = vote_str.data(using: .utf8)else {fatalError("Error in data")}
//
//                guard let vote2 = try?JSONDecoder().decode(Vote2.self, from: voteData) else {fatalError("Data note stored correctly")}
//                return vote2
//            }
            
            let hasVotedInRoundOne = record["hasVotedInRoundOne"] as! [String]

                        
            //second round
            let chosenRestaurants_str = record["chosenRestaurants"] as! [String]
//            let chosenRestaurants = chosenRestaurants_str.map{
//                (restaurant) -> RestaurantInfo in
//                let restaurant_str = restaurant as! String
//                guard let restaurantData = restaurant_str.data(using: .utf8)else {fatalError("Error in data")}
//
//                guard let restaurant = try?JSONDecoder().decode(RestaurantInfo.self, from: restaurantData) else {fatalError("Data note stored correctly")}
//                return restaurant
//            }
            
            let votesForEachRestaurant_str = record["votesForEachRestaurant"] as! [String]
//            let votesForEachRestaurant = votesForEachRestaurant_str.map{
//                (vote) -> Vote2 in
//                let vote_str = vote as! String
//                guard let voteData = vote_str.data(using: .utf8)else {fatalError("Error in data")}
//
//                guard let vote2 = try?JSONDecoder().decode(Vote2.self, from: voteData) else {fatalError("Data note stored correctly")}
//                return vote2
//            }
            let hasVotedInRoundTwo = record["hasVotedInRoundTwo"] as! [String]
            
            //Winners
            let winningCuisineIndex = record["winningCuisineIndex"] as! Int
            let winningRestaurantIndex = record["winningRestaurantIndex"] as! Int
            
            let surveyCloud = SurveyCloud.init(leaderID: leaderID, participantCount: participantCount, currentRound: currentRound, chosenCuisines: chosenCuisines, votesForEachCuisine: votesForEachCuisine_str, hasVotedInRoundOne: hasVotedInRoundOne, chosenRestaurants: chosenRestaurants_str, votesForEachRestaurant: votesForEachRestaurant_str, hasVotedInRoundTwo: hasVotedInRoundTwo, winningCuisineIndex: winningCuisineIndex, winningRestaurantIndex: winningRestaurantIndex)
            return surveyCloud
            
        }
        catch {
            fatalError("Unexpected error: \(error).")
        }
    }
    
}
