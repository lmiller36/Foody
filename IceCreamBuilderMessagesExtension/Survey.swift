//
//  Survey.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by user on 1/4/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import CloudKit
///All information concerning a survey
///
/// - important:
///     Fields in the survey become populated when state reached in the current survey

class Survey {
    static let sharedInstance = Survey.init()
    static let filename = "Survey.json"
    static let className = "SurveyCloud"
    
    ///Survey's alphanumeric id
    public var recordID:String?
    
    public var record:CKRecord?
    
    ///Leader's cuisine selection
    public var firstRoundOptions : DiningOptions?
    public var firstRoundVotes : [Vote2]
    public var firstRoundParticipants : [String]
    
    ///Leader's restaurant selection
    public var secondRoundOptions : DiningOptions?
    public var secondRoundVotes : [Vote2]
    public var secondRoundParticipants : [String]
    
    
    ///Count of voting participants (does not include the leader)
    public var participatingMemberCount : Int?
    
    ///Group agreed upon cuisine
    public var categoryWinner : DiningOption?
    
    ///Information pertaining the restaurant
    private var restaurantInfo : [RestaurantInfo]?
    
    public var participantUUID:String?
    
    public var leaderID : String?
    
    public var isLeader:Bool
    
    public var appState:AppState
    
    private var approvedIDs : [String]?
    
    init(){
        self.isLeader = true
        self.appState = AppState.MainMenu
        self.firstRoundVotes = [Vote2]()
        self.secondRoundVotes = [Vote2]()
        self.firstRoundParticipants = [String]()
        self.secondRoundParticipants = [String]()
        
    }
    
    func getRecord()->CKRecord{
        //        if let record = self.record {
        //            switch self.appState {
        //            case AppState.CategorySelection:
        //                record.set
        //            }
        //        }
        //        else {
        return createRecordID()
        // }
    }
    
    func createRecordID() -> CKRecord{
        //A survey is already in progress
        let record:CKRecord
        if let savedRecord = self.record {
            record = savedRecord
        }
        else {
            record = CKRecord(recordType: Survey.className)
            
        }
        let surveyCloud = self.toSurveyCloud()
        
        let dict = surveyCloud.getDict()
        print("dict")
        print(dict)
        for key in dict.keys {
            print("key: \(key)")
            let value = dict[key]
            record.setObject(value, forKey: key)
            
        }
        print("record")
        //            guard let encodedData = try? JSONEncoder().encode(surveyCloud) else {fatalError("Encoding Failed")}
        //            let encodedDataStr = String(decoding: encodedData, as: UTF8.self)
        //
        //            survey.setObject(encodedDataStr as CKRecordValue, forKey: "data")
        return record
        
    }
    
    func addVotes(votes:[Vote2]) {
        
        guard let participantID = self.participantUUID else {fatalError("Participant UUID not saved")}
        
        switch appState {
        case AppState.CategorySelection:
            self.firstRoundVotes.append(contentsOf: votes)
            self.firstRoundParticipants.append(participantID)
        case AppState.RestaurantSelection:
            self.secondRoundVotes.append(contentsOf:votes)
            self.secondRoundParticipants.append(participantID)
            
        default:
            fatalError("Voting not possibly from this state")
        }
    }
    
    func populateSurvey(surveyCloud : SurveyCloud) {
        print("Populating")
        /**
         let leaderID : String
         let participantCount : Int
         let currentRound : String
         
         //first round
         let chosenCuisines : [String]
         let votesForEachCuisine : [Vote2]
         let hasVotedInRoundOne : [String]
         
         //second round
         let chosenRestaurants : [RestaurantInfo]
         let votesForEachRestaurant : [Vote2]
         let hasVotedInRoundTwo : [String]
         
         //Winners
         let winningCuisineIndex : Int
         let winningRestaurantIndex : Int
         */
        
        guard let participantIdentifier = self.participantUUID else {fatalError("Participant UUID not set")}
        guard let numberOfParticipants = self.participatingMemberCount else {fatalError("Participant Count not set")}
        
        self.leaderID = surveyCloud.leaderID
        self.participatingMemberCount = surveyCloud.participantCount
        self.appState = AppState(rawValue: surveyCloud.currentRound)!
        
        self.firstRoundOptions = DiningOptions.init(diningOptions: surveyCloud.chosenCuisines.map{cuisine in
            return cuisineToDiningOption(cuisine_str: cuisine)
        })
        
        self.firstRoundVotes = surveyCloud.votesForEachCuisine.map{
            (vote_str) -> Vote2 in
            guard let decodedData = vote_str.data(using: .utf8) else {fatalError("Data could not be decoded")}
            
            guard let decodedVote = try?JSONDecoder().decode(Vote2.self, from: decodedData) else {fatalError("Data not sent as message struct")}
            return decodedVote
        }
        
        self.firstRoundParticipants = surveyCloud.hasVotedInRoundOne
        
        self.secondRoundOptions = DiningOptions.init(diningOptions: surveyCloud.chosenRestaurants.map{restaurant in
            return restaurantToDiningOption(restaurantInfo_str: restaurant)
        })
        
        self.secondRoundParticipants = surveyCloud.hasVotedInRoundTwo
        
        self.isLeader = surveyCloud.leaderID == participantIdentifier
        print("Leader:\(String(self.isLeader))")
        //if leader and round is over, tally votes
        if(self.isLeader) {
          
            let categorySelectionRoundFinished = self.appState == AppState.CategorySelection && self.firstRoundParticipants.count == numberOfParticipants
            let restaurantSelectionRoundFinished = self.appState == AppState.RestaurantSelection && self.secondRoundParticipants.count == numberOfParticipants
            
            print(categorySelectionRoundFinished)
            print(restaurantSelectionRoundFinished)
            
            if(categorySelectionRoundFinished || restaurantSelectionRoundFinished){
                self.tallyResults()
                self.appState = self.appState.NextState()
                print(self.appState)
            }
            else {
                self.appState = AppState.Wait
            }
        }
            //participant of survey
        else {
            //check if participant has already voted
            print(surveyCloud)
            let waitRound1 = self.firstRoundParticipants.contains(participantIdentifier) && self.appState == AppState.CategorySelection
            
            let waitRound2 = self.secondRoundParticipants.contains(participantIdentifier) && self.appState == AppState.RestaurantSelection
            
            if (waitRound1 || waitRound2){
                self.appState = AppState.Wait
            }
        }
        
        print(self.appState)
        
    }
    
    func cuisineToDiningOption(cuisine_str:String) -> DiningOption {
        
        guard let grouping = Grouping.init(rawValue : cuisine_str) else {fatalError("Unexpected grouping value")}
        let cuisine =  Cuisines.getCuisine(grouping: grouping)
        
        return cuisine.displayInformation
    }
    
    func restaurantToDiningOption(restaurantInfo_str:String) -> DiningOption {
        
        guard let decodedData = restaurantInfo_str.data(using: .utf8) else {fatalError("Data could not be decoded")}
        
        guard let decodedRestaurantInfo = try?JSONDecoder().decode(RestaurantInfo.self, from: decodedData) else {fatalError("Data not sent as restaurant Info")}
        
        let category = decodedRestaurantInfo.getCategory()
        guard let grouping = Grouping.init(rawValue : category.title) else {fatalError("Unexpected grouping value")}
        let cuisine =  Cuisines.getCuisine(grouping: grouping).displayInformation
        
        let diningOption = DiningOption.init(cuisine: category.title, image: cuisine.image, restaurant: decodedRestaurantInfo)
        
        return diningOption
    }
    
    func toSurveyCloud() -> SurveyCloud {
        print("SURVEY CLOUD")
        guard let leaderID  = self.leaderID else {fatalError("Leader id was not set")}
        guard let participantCount  = self.participatingMemberCount else {fatalError("Participant count was not set")}
        
        guard let chosenCuisines = self.firstRoundOptions?.diningOptions.map({ (diningOption) -> String in
            return diningOption.cuisine
        }) else {fatalError("FirstRoundOptions not set")}
        
        var firstRoundVotesStrArr = [String]()
        for vote in self.firstRoundVotes {
            guard let encodedVote = try? JSONEncoder().encode(vote) else {fatalError("Encoding Failed")}
            let encodedVoteStr = String(decoding: encodedVote, as: UTF8.self)
            firstRoundVotesStrArr.append(encodedVoteStr)
        }
        
        let chosenRestaurants = self.secondRoundOptions?.diningOptions.map({ (diningOption) -> String in
                        guard let encodedData = try? JSONEncoder().encode(diningOption.restaurant) else {fatalError("Encoding Failed")}
                        let encodedDataStr = String(decoding: encodedData, as: UTF8.self)
            return encodedDataStr
        }) ?? []
        
        var secondRoundVotesStrArr = [String]()
        for vote in self.secondRoundVotes {
            guard let encodedVote = try? JSONEncoder().encode(vote) else {fatalError("Encoding Failed")}
            let encodedVoteStr = String(decoding: encodedVote, as: UTF8.self)
            secondRoundVotesStrArr.append(encodedVoteStr)
        }
        
        let surveyCloud =  SurveyCloud.init(leaderID: leaderID, participantCount: participantCount, currentRound: self.appState.rawValue, chosenCuisines: chosenCuisines, votesForEachCuisine: firstRoundVotesStrArr, hasVotedInRoundOne: self.firstRoundParticipants, chosenRestaurants: chosenRestaurants, votesForEachRestaurant: secondRoundVotesStrArr, hasVotedInRoundTwo: self.secondRoundParticipants, winningCuisineIndex: -1, winningRestaurantIndex: -1)
        
        return surveyCloud
    }
    
    //
    func tallyResults(){
        var highestIndex = -1
        var highest_cuisine = ""
       var highest_number_of_votes = -1
        var highestCuisineOption:DiningOption?
        
        var count = 0
        let options : DiningOptions
        let votes : [Vote2]
        if (self.appState == AppState.CategorySelection){
            guard let firstRoundOptions = self.firstRoundOptions else {fatalError("First round options not present")}
            options = firstRoundOptions
            votes = self.firstRoundVotes
        }
        else
        {
            guard let secondRoundOptions = self.secondRoundOptions else {fatalError("Second round options not present")}
            options = secondRoundOptions
            votes = self.secondRoundVotes
        }
        
        for option in options.diningOptions {
            let numberOfVotes = votes.filter{$0.name == option.cuisine && $0.approved}.count
            
            if(numberOfVotes > highest_number_of_votes){
                highestCuisineOption = option
                highestIndex = count
                highest_number_of_votes = numberOfVotes
                highest_cuisine = option.cuisine
            }
            
            count += 1
        }
        
        print(highest_cuisine)
        print(highest_cuisine)
        
        if(self.appState == AppState.CategorySelection){
            self.categoryWinner = highestCuisineOption
        }
        
        //        var votes_for_first = 0 , votes_for_second = 0 , votes_for_third = 0
        //
        //        for vote in self.participantsVotes {
        //            if(vote.vote1.approved){ votes_for_first += 1 }
        //            if(vote.vote2.approved){ votes_for_second += 1 }
        //            if(vote.vote3.approved){ votes_for_third += 1 }
        //        }
        //
        //        let maximum = max(votes_for_first,votes_for_second,votes_for_third)
        //        var highestVote : Vote?
        //
        //        let indexOfHighest : Int
        //
        //        let vote = self.participantsVotes[0]
        //
        //        if(votes_for_first == maximum) {
        //            indexOfHighest = 0
        //            highestVote = vote.vote1
        //        }
        //        else if(votes_for_second == maximum){
        //            indexOfHighest = 1
        //            highestVote = vote.vote2
        //        }
        //        else {
        //            indexOfHighest = 2
        //            highestVote = vote.vote3
        //        }
        //
        //        if let highestVote = highestVote {
        //            //Tallying votes for Cuisine
        //            print(self.firstRoundVotes)
        //            if(appstate == AppState.CategorySelection) {
        //                let category = highestVote.cuisine
        //                guard let grouping = Grouping.init(rawValue : highestVote.cuisine) else {fatalError("Unexpected grouping value")}
        //                let cuisine =  Cuisines.getCuisine(grouping: grouping)
        //                let image = cuisine.displayInformation.image
        //                self.categoryWinner = DiningOption.init(cuisine: category, image: image, restaurant: Optional<RestaurantInfo>.none)
        //
        //                self.firstRoundVotes = self.participantsVotes
        //
        //                self.participantsVotes.removeAll()
        //            }
        //                //Tallying votes for restaurant
        //            else if(appstate == AppState.RestaurantSelection){
        //                //the participant does not send the restaurant id, so we must check against the leader's saved value for the ranking
        //
        //                guard let restaurantInfo = self.restaurantInfo else {fatalError("No restaurant info present")}
        //
        //                print(restaurantInfo)
        //
        //                let winningRestaurantInfo = restaurantInfo[indexOfHighest]
        //
        //                print(winningRestaurantInfo)
        //
        //                let winningDiningOption = DiningOption.init(cuisine: winningRestaurantInfo.getCategory().title, image: getType(type: winningRestaurantInfo.getCategory().alias).image, restaurant: winningRestaurantInfo)
        //
        //                print(winningDiningOption)
        //
        //                    self.winningRestaurant = winningDiningOption
        //
        //            }
        //            else {
        //                fatalError("\(appstate) not valid")
        //            }
        //        }
    }
    
    
}

/// Visible choice's on both leader and participant screens. Can be easily configured should a survey group require a different number of choices
///
/// Parameters:
/// - **option1**: The *first* dining option.
/// - **option2**: The *second* dining option.
/// - **option3**: The *third* dining option.
public struct DiningOptions {
    
    //TODO: allow configurability (3+ dining options)
    
    var diningOptions : [DiningOption]
    
    func getOption(index:Int)->DiningOption{
        return diningOptions[index]
    }
}

/// A Cacheable representation of a survey at any point in the process
///
/// Parameters:
/// - **surveyID**: Survey's alphanumeric identification string
/// - **participantCount**: Number of participating members in the current survey.
/// - **votes**: All recorded votes in the current survey.
/// - **firstRoundOptions**: Leader's selection of restaurant cuisines.
/// - **secondRoundOptions**: Leader's choice of restaurants
/// - **queryString**: URL for Yelp API.
struct CacheableSurvey : Codable {
    //
    //    let surveyID : SurveyID
    //
    //    //TODO: Can this change if people opt out?
    //    let participantCount : Int
    //
    //    //TODO: Change to first and second round so information is not lost
    //    let firstRoundVotes : [ParticipantVote]
    //    let secondRoundVotes : [ParticipantVote]
    //
    //    let votes : [ParticipantVote]
    //
    //    let firstRoundOptions : [Vote]
    //
    //    let secondRoundOptions : [Vote]
    //    let restaurantInfo : [RestaurantInfo]
    //
    //    let winningRestaurantID : String
    //
    //    let queryString : String?
    
}


///// Identification for a given Survey
/////
///// Parameters:
///// - **id**: 25 character alphanumberic id
//public struct SurveyID : Codable {
//    let id : String
//
//    static func generate() -> SurveyID{
//        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
//        let lengthOfAlphanumeric = 25
//        let randomString = String((0...lengthOfAlphanumeric-1).map{ _ in letters.randomElement()! })
//        return SurveyID.init(id: randomString)
//    }
//}
