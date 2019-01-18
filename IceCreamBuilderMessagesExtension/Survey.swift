//
//  Survey.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by user on 1/4/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

///All information concerning a survey
///
/// - important:
///     Fields in the survey become populated when state reached in the current survey

class Survey {
    static let sharedInstance = Survey.init()
    static let filename = "Survey.json"
    
    ///Survey's alphanumeric id
    private var surveyID : SurveyID?
    
    ///Leader's cuisine selection
    private var firstRoundOptions : DiningOptionTuplet?
    
    ///Leader's restaurant selection
    private var secondRoundOptions : DiningOptionTuplet?
    
    ///Votes from each participant in the first round
    private var firstRoundVotes : [ParticipantVote]
    
    ///Votes from each participant
    private var participantsVotes : [ParticipantVote]
    
    ///Count of voting participants (does not include the leader)
    private var participatingMemberCount : Int?
    
    //TODO: is this and firstRoundOptions needed??
    ///Leader's cuisine selection2
    private var leaderCategorySelection : [Vote]?
    
    
    private var secondRoundVotes : [ParticipantVote]

    ///Group agreed upon cuisine
    private var categoryWinner : DiningOption?
    
    ///Leader's restaurant selection2
    private var leaderRestaurauntSelection : [Vote]?
    private var winningRestaurant : RestaurantInfo?
    
    ///URL to be queried with Yelp API
    private var queryString : String?
    
    private var approvedIDs : [String]?
    
    init(){
        self.participantsVotes = [ParticipantVote]()
        self.firstRoundVotes = [ParticipantVote]()
        self.secondRoundVotes = [ParticipantVote]()
    }
    
    func repopulateSurvey(cacheableSurvey:CacheableSurvey) {
        //repopulate datafields of survey from cached version
        self.surveyID = cacheableSurvey.surveyID
        self.participantsVotes = cacheableSurvey.votes
        self.participatingMemberCount = cacheableSurvey.participantCount
        self.leaderCategorySelection = cacheableSurvey.firstRoundOptions
    }
    
    func tallyResults(){
        
        
        
        var votes_for_first = 0 , votes_for_second = 0 , votes_for_third = 0
        
        for vote in self.participantsVotes {
            if(vote.vote1.approved){ votes_for_first += 1 }
            if(vote.vote2.approved){ votes_for_second += 1 }
            if(vote.vote3.approved){ votes_for_third += 1 }
        }
        
        let maximum = max(votes_for_first,votes_for_second,votes_for_third)
        var highestVote : Vote?
        
        let vote = self.participantsVotes[0]
        
        if(votes_for_first == maximum) {
            highestVote = vote.vote1
        }
        else if(votes_for_second == maximum){
            highestVote = vote.vote2
        }
        else {
            highestVote = vote.vote3
        }
        
        if let highestVote = highestVote {
            if(self.firstRoundVotes.count == 0) {
            let category = highestVote.cuisine
            guard let grouping = Grouping.init(rawValue : highestVote.cuisine) else {fatalError("Unexpected grouping value")}
             let cuisine =  Cuisines.getCuisine(grouping: grouping)
            let image = cuisine.displayInformation.image
            self.categoryWinner = DiningOption.init(cuisine: category, image: image, restaurant: Optional<RestaurantInfo>.none)
        
            self.firstRoundVotes = self.participantsVotes
                
            self.participantsVotes.removeAll()
            }
            else {
                let 
            }
        }
    }
    
    func getCategoryWinner() -> DiningOption {
        guard let categoryWinner = self.categoryWinner else{fatalError("Votes have not yet been tallied")}
        return categoryWinner
    }
    
    func populateSurveyID(surveyID : SurveyID){
        self.surveyID = surveyID
    }
    
    func receivedFirstRoundOptions (firstRoundOptions:DiningOptionTuplet){
        self.firstRoundOptions = firstRoundOptions
    }
    
    func receivedSecondRoundOptions (secondRoundOptions:DiningOptionTuplet){
        self.secondRoundOptions = secondRoundOptions
    }
    
    func setApprovedRestaurants(restaurantIDs : [String]) {
        self.approvedIDs = restaurantIDs
    }
    
    
    func setParticipatingMemberCount(count : Int){
        self.participatingMemberCount = count
    }
    
    func setQueryString(queryString : String){
        self.queryString = queryString
    }
    
    func getApprovedRestaurants()->[String]{
        guard let approvedIDs = self.approvedIDs else{fatalError("ApprovedIDs has not been set")}
        return approvedIDs
    }
    
    func getQueryString()->String{
           guard let queryString = self.queryString else{fatalError("Query String has not been set")}
        return queryString
    }
    
    func setLeaderCategorySelection(leaderSelection : [Vote]){
        self.leaderCategorySelection = leaderSelection
        
        Survey.writeCache(survey: self)
    }
    
    func setLeaderRestaurantSelection(leaderSelection : [Vote],queryString : String){
        self.queryString = queryString
        self.leaderRestaurauntSelection = leaderSelection
        
        Survey.writeCache(survey: self)
    }
    
    
    func appendParticipantsVotes (vote : ParticipantVote){
        
        let voteHasBeenCounted = self.participantsVotes.contains{$0.participantUUID == vote.participantUUID}

        if(!voteHasBeenCounted) {
            self.participantsVotes.append(vote)
        }
        
        Survey.writeCache(survey: self)

    }
    
    func roundIsFinished()->Bool{
        if let participatingMemberCount = self.participatingMemberCount {
            return participatingMemberCount == self.participantsVotes.count
        }
        
        return false
    }
    
    func getSecondRoundOptions() -> DiningOptionTuplet {
        guard let secondRoundOptions = self.secondRoundOptions else {fatalError("No options present")}
        guard self.surveyID != nil else {fatalError("Cannot proceed without a surveyID")}
        
        return secondRoundOptions
    }
    
    func getFirstRoundOptions() -> DiningOptionTuplet {
        guard let firstRoundOptions = self.firstRoundOptions else {fatalError("No options present")}
        guard self.surveyID != nil else {fatalError("Cannot proceed without a surveyID")}
        
        return firstRoundOptions
    }
    
    func toString () -> String {
        
        let cacheableSurvey = Survey.toCacheableSurvey(survey: self)
        
        //encode cacheable survey
        guard let encodedData = try? JSONEncoder().encode(cacheableSurvey) else {fatalError("Encoding Failed")}
        let encodedDataStr = String(decoding: encodedData, as: UTF8.self)
        
        return encodedDataStr
    }
    
    public static func readFromCache() -> CacheableSurvey?{
        if Storage.fileExists(Survey.filename, in: .caches) {
            
            // we have a cached survey to retrieve
            let cachedSurvey = Storage.retrieve(Survey.filename, from: .caches, as: CacheableSurvey.self)
            return cachedSurvey
            
        }
        else{
            return Optional<CacheableSurvey>.none
        }
    }
    
    public static func toCacheableSurvey(survey: Survey) -> CacheableSurvey {
        
        guard let surveyID = survey.surveyID else {fatalError("No survey ID present")}
        guard let participantCount = survey.participatingMemberCount else {fatalError("No member count present")}
        guard let firstRoundLeaderOptions = survey.leaderCategorySelection else {fatalError("No Leader options present")}
        
          let secondRoundLeaderOptions = survey.leaderRestaurauntSelection ?? []
        
        let cacheableSurvey = CacheableSurvey.init(surveyID: surveyID, participantCount: participantCount, firstRoundVotes:survey.firstRoundVotes, secondRoundRoundVotes: survey.secondRoundVotes, votes: survey.participantsVotes, firstRoundOptions: firstRoundLeaderOptions,secondRoundOptions:secondRoundLeaderOptions,queryString:survey.queryString)
        
        return cacheableSurvey
    }
    
    fileprivate static func removeCachedSurvey(){
        
        
        Storage.remove(Survey.filename, from: .caches)
        
    }
    
    fileprivate static func writeCache(survey:Survey){
        
        let cacheableSurvey = toCacheableSurvey(survey: survey)
        
        Storage.store(cacheableSurvey, to: .caches, as: Survey.filename)
    }
    
}

/// Visible choice's on both leader and participant screens. Can be easily configured should a survey group require a different number of choices
///
/// Parameters:
/// - **option1**: The *first* dining option.
/// - **option2**: The *second* dining option.
/// - **option3**: The *third* dining option.
public struct DiningOptionTuplet {
    
    //TODO: allow configurability (3+ dining options)
    
    var option1 : DiningOption
    var option2 : DiningOption
    var option3 : DiningOption
    
    func getOption(index:Int)->DiningOption{
        switch index {
        case 0:
            return option1
        case 1:
            return option2
        case 2:
            return option3
        default:
            fatalError("OutOfBounds")
        }
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
    
    let surveyID : SurveyID
    
    //TODO: Can this change if people opt out?
    let participantCount : Int
    
    //TODO: Change to first and second round so information is not lost
    let firstRoundVotes : [ParticipantVote]
    let secondRoundRoundVotes : [ParticipantVote]

    let votes : [ParticipantVote]
    
    let firstRoundOptions : [Vote]
    
    let secondRoundOptions : [Vote]
    
    let queryString : String?
    
}

/// Participant's choices in a round
///
/// Parameters:
/// - **vote1**: The user's *first* vote.
/// - **vote2**: The user's *second* vote.
/// - **vote3**: The user's *third* vote.
/// - **participantUUID**: User's identifying UUID string, as per the Leader's view
struct ParticipantVote : Codable {

    let vote1 : Vote
    let vote2 : Vote
    let vote3 : Vote
    
    let participantUUID : String
    
    static func fromMessageStruct(message : MessageStruct) -> ParticipantVote{
        let vote1 = message.vote1
        let vote2 = message.vote2
        let vote3 = message.vote3
        
        let participantUUID = message.messageSender
        
        return ParticipantVote.init(vote1: vote1,vote2: vote2,vote3: vote3,participantUUID: participantUUID)
    }
}

/// Identification for a given Survey
///
/// Parameters:
/// - **id**: 25 character alphanumberic id
public struct SurveyID : Codable {
    let id : String
    
    static func generate() -> SurveyID{
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let lengthOfAlphanumeric = 25
        let randomString = String((0...lengthOfAlphanumeric-1).map{ _ in letters.randomElement()! })
        return SurveyID.init(id: randomString)
    }
}
