/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 The root view controller shown by the Messages app.
 */

import UIKit
import Messages
import CoreLocation
class MessagesViewController: MSMessagesAppViewController {
    
    static var presentationStyle = MSMessagesAppPresentationStyle.compact
    
    var stateOfApp = AppState.MainMenu
    var leaderOfSurvey : String?
    
    var surveyID : SurveyID?
    var remainingParticipants,completedParticipants : [String]?
    var myIdentifier : UUID?
    var isLeader = false
    var numberOfParticipants : Int?
    var appQueryItems = [URLQueryItem]()
    var savedAppData = [String : Int]()
    //    var hasCached = false
    
    public static let DATA = "DATA"
    public static let LEADER = "Leader"
    public static let CURRENT_ROUND = "CurrentRound"
    public static let REMAINING_PARTICIPANTS = "RemainingParticipants"
    public static let COMPLETED_PARTICIPANTS = "CompletedParticipants"
    public static let DELIMETER = "|"
    //    public static let NUMBER_OF_RESTAURANTS = "NumberOfRestaurants"
    //    public static let SURVEY_STARTING_LOCATION_LAT = "SurveyStartingLocationLat"
    //    public static let SURVEY_STARTING_LOCATION_LNG = "SurveyStartingLocationLng"
    //    public static let NUMBER_OF_PARTICIPANTS = "NumberOfParticipants"
    //
    override func willBecomeActive(with conversation: MSConversation) {
        super.willBecomeActive(with: conversation)
        
        // Present the view controller appropriate for the conversation and presentation style.
        presentViewController(for: conversation, with: presentationStyle)
    }
    
    // MARK: MSMessagesAppViewController overrides
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        print(presentationStyle)
        super.willTransition(to: presentationStyle)
        
        // Hide child view controllers during the transition.
        removeAllChildViewControllers()
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        super.didTransition(to: presentationStyle)
        
        // Present the view controller appropriate for the conversation and presentation style.
        guard let conversation = activeConversation else { fatalError("Expected an active converstation") }
        presentViewController(for: conversation, with: presentationStyle)
    }
    
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        print("yo, in here!")
        print(message.url)
    }
    
    // MARK: Child view controller presentation
    
    private func presentViewController(for conversation: MSConversation, with presentationStyle: MSMessagesAppPresentationStyle) {
        
        
        let survey = SurveyID.generate()
        print(survey.id)
        let url = conversation.selectedMessage?.url
        
        self.leaderOfSurvey = conversation.localParticipantIdentifier.uuidString
        
        // go to setup if need
        self.stateOfApp = UserData.sharedInstance.isCacheDataAvailable() ? AppState.MainMenu : AppState.Setup
        self.myIdentifier = conversation.localParticipantIdentifier
        
        //defaults to true, and changed if necessary with the message struct
        self.isLeader = true
        
        //defaults to number in conversation (not including the leader)
        self.numberOfParticipants = conversation.remoteParticipantIdentifiers.count
        
        
        
        //there has been at least one round
        if let queryItems = URLComponents(string: url?.absoluteString ?? "")?.queryItems {
            guard let savedMessage =  queryItems.filter({$0.name == MessagesViewController.DATA}).first?.value else {fatalError("Data was not received")}
            
            guard let decodedData = savedMessage.data(using: .utf8) else {fatalError("Data could not be decoded")}
            
            guard let decodedMessageStruct = try?JSONDecoder().decode(MessageStruct.self, from: decodedData) else {fatalError("Data not sent as message struct")}
            
            print(decodedMessageStruct)
            
            self.leaderOfSurvey = decodedMessageStruct.leader
            self.isLeader = self.leaderOfSurvey == conversation.localParticipantIdentifier.uuidString
            
            guard let nextState = AppState.init(rawValue:  decodedMessageStruct.state) else {fatalError("unexpected App State")}
            
            if(nextState == AppState.CategorySelection){
                
                // if leader do something different
                if(!self.isLeader) {
                    
                    let category1 = decodedMessageStruct.vote1.cuisine
                    
                    guard let grouping1 = Grouping.init(rawValue : decodedMessageStruct.vote1.cuisine) else {fatalError("Unexpected grouping value")}
                    let cuisine1 =  Cuisines.getCuisine(grouping: grouping1)

                    let image1 = cuisine1.displayInformation.image
                    let option1 = DiningOption.init(cuisine: category1, image: image1, restaurant: Optional<RestaurantInfo>.none)
                    
                    let category2 = decodedMessageStruct.vote2.cuisine
                    guard let grouping2 = Grouping.init(rawValue : decodedMessageStruct.vote2.cuisine) else {fatalError("Unexpected grouping value")}
                    let cuisine2 =  Cuisines.getCuisine(grouping: grouping2)

                    let image2 = cuisine2.displayInformation.image
                    let option2 = DiningOption.init(cuisine: category2, image: image2, restaurant: Optional<RestaurantInfo>.none)
                    
                    let category3 = decodedMessageStruct.vote3.cuisine
                    guard let grouping3 = Grouping.init(rawValue : decodedMessageStruct.vote3.cuisine) else {fatalError("Unexpected grouping value")}
                    let cuisine3 =  Cuisines.getCuisine(grouping: grouping3)

                    let image3 = cuisine3.displayInformation.image
                    let option3 = DiningOption.init(cuisine: category3, image: image3, restaurant: Optional<RestaurantInfo>.none)
                    
                    let leadersSelection = DiningOptionTuplet.init(option1: option1, option2: option2, option3: option3)
                    
                    Survey.sharedInstance.receivedFirstRoundOptions(firstRoundOptions: leadersSelection)
                }
                    //you are the leader and have clicked on a participants vote
                else if (decodedMessageStruct.messageSender != conversation.localParticipantIdentifier.uuidString) {
                    print("Add participant's Vote!!")
                    
                    //repopulate Survey from saved cache data
                    guard let savedCacheData = Survey.readFromCache() else {fatalError("No saved cache data")}
                    
                    let surveyIDsMatch = savedCacheData.surveyID.id == decodedMessageStruct.surveyID
                    
                    if (surveyIDsMatch) {
                        
                        Survey.sharedInstance.repopulateSurvey(cacheableSurvey: savedCacheData)
                        
                        let participantVote = ParticipantVote.fromMessageStruct(message: decodedMessageStruct)
                        Survey.sharedInstance.appendParticipantsVotes(vote: participantVote)
                        
                        print(Survey.sharedInstance.toString())
                        
                    }
                    else {
                        print("survey id's did not match")
                    }
                }
            }
            else if(nextState == AppState.RestaurantSelection){
                
            }
            
            let savedSurveyID = SurveyID.init(id: decodedMessageStruct.surveyID)
            Survey.sharedInstance.populateSurveyID(surveyID: savedSurveyID)
            self.surveyID = savedSurveyID
            
            if(self.isLeader) {
                print(Survey.sharedInstance.toString())
            }
            
            //check if leader ... so go to wait
            if(self.isLeader){
                
                //if survey is finished, advance to the next state
                if(Survey.sharedInstance.roundIsFinished()) {
                    self.stateOfApp = nextState.NextState()
                }
                    //the round is finished
                else {
                    self.stateOfApp = AppState.Wait
                }
                
            }
            else {
                self.stateOfApp = nextState
            }
        }
        
        if(!(self.remainingParticipants != nil)) {
            self.remainingParticipants = conversation.remoteParticipantIdentifiers.map{$0.uuidString}
        }
        
        switchState(newState: self.stateOfApp)
        
    }
    
    private func instantiateInitialSetupController() -> UIViewController {
        // Instantiate a `StartMenuViewController`.
        guard let controller = storyboard?.instantiateViewController(withIdentifier: InitialSetupViewController.storyboardIdentifier)
            as? InitialSetupViewController
            else { fatalError("Unable to instantiate a StartMenuViewController from the storyboard") }
        
        controller.delegate = self
        
        return controller
    }
    
    
    private func instantiateStartMenuController() -> UIViewController {
        // Instantiate a `StartMenuViewController`.
        guard let controller = storyboard?.instantiateViewController(withIdentifier: MainMenuViewController.storyboardIdentifier)
            as? MainMenuViewController
            else { fatalError("Unable to instantiate a StartMenuViewController from the storyboard") }
        
        controller.delegate = self
        
        return controller
    }
    
    
    private func instantiateWaitingViewController() -> UIViewController {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: WaitingViewController.storyboardIdentifier)
            as? WaitingViewController
            else { fatalError("Unable to instantiate an WaitingViewController from the storyboard") }
        
        //        controller.delegate = self
        
        return controller
    }
    
    private func instantiateLeaderVotingController() -> UIViewController {
        // Instantiate a `StartMenuViewController`.
        guard let controller = storyboard?.instantiateViewController(withIdentifier: LeaderVotingViewController.storyboardIdentifier)
            as? LeaderVotingViewController
            else { fatalError("Unable to instantiate a StartMenuViewController from the storyboard") }
        
        //populate surveyID , which has not yet been generated
        let newSurveyID = SurveyID.generate()
        self.surveyID = newSurveyID
        Survey.sharedInstance.populateSurveyID(surveyID: newSurveyID)
        
        //populate participant count in survey
        guard let participantCount = self.numberOfParticipants else {fatalError("Number of participants not present")}
        Survey.sharedInstance.setParticipatingMemberCount(count: participantCount)
        
        controller.delegate = self
        
        return controller
    }
    
    
    private func instantiateParticipantViewController() -> UIViewController {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: ParticipantViewController.storyboardIdentifier)
            as? ParticipantViewController
            else { fatalError("Unable to instantiate an ParticipantViewController from the storyboard") }
        
        controller.delegate = self
        
        return controller
    }
    
    
    private func instantiateLeaderRestaurantViewController() -> UIViewController {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: LeaderRestaurantViewController.storyboardIdentifier)
            as? LeaderRestaurantViewController
            else { fatalError("Unable to instantiate an ParticipantViewController from the storyboard") }
        
        Survey.sharedInstance.tallyResults()
        
        controller.delegate = self
        
        return controller
    }
    
    
    
    
    private func initializeController(){
        
        removeAllChildViewControllers()
        
        /// - Tag: PresentViewController
        let controller: UIViewController
        
        switch self.stateOfApp {
        case AppState.Setup :
            controller = instantiateInitialSetupController()
        case AppState.MainMenu:
            controller = instantiateStartMenuController()
        case AppState.CategorySelection:
            if(self.isLeader){
                controller = instantiateLeaderVotingController()
            }
            else {
                controller = instantiateParticipantViewController()
            }
        case AppState.RestaurantSelection :
            if(self.isLeader){
                controller = instantiateLeaderRestaurantViewController()
            }
            else {
                controller = instantiateParticipantViewController()
            }
        case AppState.Wait:
            controller = instantiateWaitingViewController()
        default :
            //#TODO handle when a user tries to enter a survey they are not a part of
            controller = instantiateStartMenuController()
            print("NOT IN APP")
        }
        
        MessagesViewController.presentationStyle = self.presentationStyle
        
        addChildViewController(controller)
        controller.view.frame = view.bounds
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
        
        NSLayoutConstraint.activate([
            controller.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            controller.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            controller.view.topAnchor.constraint(equalTo: view.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        controller.didMove(toParentViewController: self)
    }
    
    private func switchState(newState:AppState){
        print("SWITCH TO \(newState)")
        self.stateOfApp = newState
        initializeController()
    }
    
    private func removeAllChildViewControllers() {
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }
    }
    
    
    
    func updateParticipants(appState:AppState,participants:[Participant])->[Participant]{
        
        var newParticipants = [Participant]()
        for participant in participants {
            var newAppState : AppState
            if(participant.currentStage == AppState.Wait) {
                newAppState = appState
            }
            else {
                newAppState = participant.currentStage
            }
            newParticipants.append(Participant.init(participantIdentifier: participant.participantIdentifier, currentStage: newAppState))
        }
        return newParticipants
    }
    
    func addConversationDetails(dictionary : [String : String]) ->  [String : String] {
        var data = [String : String]()
        data = data.merging(dictionary, uniquingKeysWith: { (first, _) in first })
        guard let leader = self.leaderOfSurvey else{ fatalError("Expected leader")}
        
        data[MessagesViewController.LEADER]  = leader
        
        if(isLeader){
            //data = dictionary
        }
        else {
            
        }
        
        //        for key in dictionary.keys {
        //            if let value = dictionary[key] {
        //                if(isLeader){
        //                    data[key] = value
        //                }
        //                else {
        //                    if let integerValue = Int(value){
        //                        if (integerValue > 0) {
        //                            print(key + ": "+value)
        //                        }
        //                        data[key] = String(integerValue)
        //                    }
        //                }
        //            }
        //        }
        
        //
        //
        //        if let remainingParticipants = self.remainingParticipants {
        //            data[MessagesViewController.REMAINING_PARTICIPANTS] = remainingParticipants.joined(separator: MessagesViewController.DELIMETER)
        //        }
        //
        //        if let completedParticipants = self.completedParticipants {
        //            data[MessagesViewController.COMPLETED_PARTICIPANTS] = completedParticipants.joined(separator: MessagesViewController.DELIMETER)
        //        }
        
        data[MessagesViewController.CURRENT_ROUND] = self.stateOfApp.NextState().rawValue
        self.stateOfApp = AppState.Wait
        
        //further down the road
        //        for key in savedAppData.keys {
        //            guard let savedVotes = savedAppData[key] else {return dictionary}
        //            guard let participantsVotes = dictionary[key] else { return dictionary}
        //            let participantVotesCount = Int(participantsVotes)
        //
        //            let combinedVotes = savedVotes + participantsVotes
        //            print(key + ":"+String(combinedVotes))
        //            data[key] =
        //        }
        
        
        
        print(data)
        
        return data
        //return data.merging(dictionary, uniquingKeysWith: { (first, _) in first })
    }
    
    //Cannot be reached from wait or booted screens
    func composeMessage(with message:MessageStruct , caption: String, session: MSSession? = nil) -> MSMessage {
        
        var components = URLComponents()
        var queryItems = [URLQueryItem]()
        
        //let encoder = JSONEncoder()
        
        //encode message
        guard let encodedData = try? JSONEncoder().encode(message) else {fatalError("Encoding Failed")}
        let encodedDataStr = String(decoding: encodedData, as: UTF8.self)
        print(encodedDataStr)
        queryItems.append(URLQueryItem(name: MessagesViewController.DATA, value:encodedDataStr))
        
        
        components.queryItems = queryItems
        
        let messageImage = Restaurant.init(icon: getType(type: "American"), blackAndWhite: false)
        
        let layout = MSMessageTemplateLayout()
        layout.image = messageImage.renderSticker(opaque: true)
        layout.caption = caption
        
        
        let message = MSMessage(session: session ?? MSSession())
        message.url = components.url!
        message.layout = layout
        
        return message
    }
    
    func shouldUpdateParticipantsState(knownParticipants:[Participant],knownNumberOfParticipants:Int,myIdentifier:UUID)->Bool {
        
        if(knownParticipants.count < knownNumberOfParticipants){
            
            return false
        }
        
        
        for participant in knownParticipants {
            //a participant still needs to complete the round
            if(participant.participantIdentifier != myIdentifier.uuidString && participant.currentStage != AppState.Wait){ //|| participant.currentStage.NextState() == self.stateOfApp) {
                return false
            }
        }
        
        
        return true
        
        
    }
    
    func createMessage(message : MessageStruct, caption:String){
        guard let conversation = activeConversation else { fatalError("Expected a conversation") }
        
        
        // Update the ice cream with the selected body part and determine a caption and description of the change.
        var messageCaption: String
        
        messageCaption = NSLocalizedString(caption, comment: "test")
        
        
        // Create a new message with the same session as any currently selected message.
        let message = composeMessage(with: message , caption: messageCaption, session: conversation.selectedMessage?.session)
        
        //todo is this the timeout tool?
        //message.shouldExpire = true
        
        var components = URLComponents()
        //components.string = "NAME"
        //            message.md.set(value:7,forKey:"yo")
        components.queryItems = self.appQueryItems
        //conversation.insertAttachment(components.url!, withAlternateFilename: Optional<String>.none)
        print(conversation)
        
        /// - Tag: InsertMessageInConversation
        // Add the message to the conversation.
        conversation.insert(message) { error in
            if let error = error {
                print(error)
                
            }
        }
    }
    
    func createMessageStruct(vote1:Vote,vote2:Vote,vote3:Vote,queryString:String?)->MessageStruct{
        let nextState = self.stateOfApp.rawValue//(self.isLeader ? self.stateOfApp : self.stateOfApp.NextState()).rawValue
        guard let leader = self.leaderOfSurvey else {fatalError("No leader found")}
        guard let myUUID = self.myIdentifier else {fatalError("No UUID found")}
        guard let surveyID = self.surveyID else {fatalError("No survey ID found")}
        let message = MessageStruct.init(state: nextState, leader: leader, messageSender:myUUID.uuidString,surveyID:surveyID.id,urlQueryString : queryString,vote1: vote1, vote2: vote2, vote3: vote3)
        
        return message
    }
}

/// Extends `MessagesViewController` to conform to the `IceCreamsViewControllerDelegate` protocol.

extension MessagesViewController: InitialSetupViewControllerDelegate,LeaderVotingViewControllerDelegate,ParticipantVotingViewControllerDelegate,LeaderRestaurantViewDelegate {
    
    func backToMainMenu() {
        stateOfApp = AppState.MainMenu
        switchState(newState: stateOfApp)
    }
    
    func addMessageToConversation(_ vote1:Vote,vote2:Vote,vote3:Vote, queryString:String?, caption:String){
        
        let message = createMessageStruct(vote1: vote1,vote2: vote2,vote3: vote3,queryString:queryString)
        print(message)
        //        let conversation_dict = addConversationDetails(dictionary:dictionary)
        //        print(conversation_dict)
        createMessage(message: message,caption:caption)
        self.stateOfApp = AppState.Wait
        switchState(newState: self.stateOfApp)
        requestPresentationStyle(.compact)
    }
    
    func changePresentationStyle(presentationStyle: MSMessagesAppPresentationStyle) {
        requestPresentationStyle(presentationStyle)
    }
    
    
}


/// Extends `MessagesViewController` to conform to the `IceCreamsViewControllerDelegate` protocol.

extension MessagesViewController: MainMenuViewControllerDelegate {
    
    func switchState_StartMenu(newState:AppState) {
        switchState(newState: newState)
    }
    
}




