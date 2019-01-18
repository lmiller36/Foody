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
    
    //TODO: give descriptions
    
    var stateOfApp = AppState.MainMenu
    var leaderOfSurvey : String?
    
    var surveyID : SurveyID?
    var remainingParticipants,completedParticipants : [String]?
    var myIdentifier : UUID?
    var isLeader = false
    var numberOfParticipants : Int?
    var appQueryItems = [URLQueryItem]()
    var savedAppData = [String : Int]()
    
    //TODO: move into separate class (if still used)
    public static let DATA = "DATA"
    //    public static let LEADER = "Leader"
    //    public static let CURRENT_ROUND = "CurrentRound"
    //    public static let REMAINING_PARTICIPANTS = "RemainingParticipants"
    //    public static let COMPLETED_PARTICIPANTS = "CompletedParticipants"
    //    public static let DELIMETER = "|"
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    override func willBecomeActive(with conversation: MSConversation) {
        super.willBecomeActive(with: conversation)
        
        // Present the view controller appropriate for the conversation and presentation style.
        presentViewController(for: conversation, with: presentationStyle)
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        super.willTransition(to: presentationStyle)
        
        // Hide child view controllers during the transition.
        removeAllChildViewControllers()
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        super.didTransition(to: presentationStyle)
        
        // Present the view controller appropriate for the conversation and presentation style.
        guard let conversation = activeConversation else { fatalError("Expected an active converstation") }
        presentViewController(for: conversation, with: presentationStyle)
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        print("yo, in here!")
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    func voteToDiningOption(vote:Vote) -> DiningOption {
        
        print(RestaurantsNearby.sharedInstance.isEmpty())
        
        let category = vote.cuisine
        
        guard let grouping = Grouping.init(rawValue : category) else {fatalError("Unexpected grouping value")}
        let cuisine =  Cuisines.getCuisine(grouping: grouping)
        
        let image = cuisine.displayInformation.image
        let diningOption = DiningOption.init(cuisine: category, image: image, restaurant: Optional<RestaurantInfo>.none)
        
        return diningOption
    }
    
    func populateDiningOptions(messageStruct:MessageStruct){
        
        guard let nextState = AppState.init(rawValue:  messageStruct.state) else {fatalError("unexpected App State")}
        
        
        if(nextState == AppState.CategorySelection) {
            let option1 = self.voteToDiningOption(vote: messageStruct.vote1)
            let option2 = self.voteToDiningOption(vote: messageStruct.vote2)
            let option3 = self.voteToDiningOption(vote: messageStruct.vote3)
            
            
            let leadersSelection = DiningOptionTuplet.init(option1: option1, option2: option2, option3: option3)
            
            print(leadersSelection)
            print(nextState)
            
            Survey.sharedInstance.receivedFirstRoundOptions(firstRoundOptions: leadersSelection)
        }
       else if(nextState == AppState.RestaurantSelection) {
            //Survey.sharedInstance.receivedSecondRoundOptions(secondRoundOptions: leadersSelection)
            
            guard let id1 = messageStruct.vote1.restaurantId else {fatalError("ID missing")}
            guard let id2 = messageStruct.vote2.restaurantId else {fatalError("ID missing")}
            guard let id3 = messageStruct.vote3.restaurantId else {fatalError("ID missing")}
            
            let IDs = [id1,id2,id3]
            
            Survey.sharedInstance.setApprovedRestaurants(restaurantIDs: IDs)
            
        }
    }
    
    // MARK: Child view controller presentation
    //TODO: break into methods
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    private func presentViewController(for conversation: MSConversation, with presentationStyle: MSMessagesAppPresentationStyle) {
        
        if(self.stateOfApp == AppState.Wait){
            switchState(newState: self.stateOfApp)
            return
        }
        
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
            print(nextState)
            if(nextState == AppState.CategorySelection || nextState == AppState.RestaurantSelection){
                
                // if leader do something different
                if(!self.isLeader) {
                    if(nextState == AppState.RestaurantSelection){
                        guard let base_url = decodedMessageStruct.urlQueryString else { fatalError("Message struct missing url query string")}
                        Survey.sharedInstance.setQueryString(queryString: base_url)
                    }
                    self.populateDiningOptions(messageStruct: decodedMessageStruct)
                }
                    //you are the leader and have clicked on a participants vote
                else if (decodedMessageStruct.messageSender != conversation.localParticipantIdentifier.uuidString) {
                    
                    print("Appending votes!")
                    
                    //repopulate Survey from saved cache data
                    guard let savedCacheData = Survey.readFromCache() else {fatalError("No saved cache data")}
                    print("Read from cache")
                    print(savedCacheData)
                    let surveyIDsMatch = savedCacheData.surveyID.id == decodedMessageStruct.surveyID
                    
                    if (surveyIDsMatch) {
                        
                        Survey.sharedInstance.repopulateSurvey(cacheableSurvey: savedCacheData)
                        
                        let participantVote = ParticipantVote.fromMessageStruct(message: decodedMessageStruct)
                        Survey.sharedInstance.appendParticipantsVotes(vote: participantVote)
                        
                    }
                    else {
                        print("survey id's did not match")
                    }
                }
            }
 
            
            //Tallying Restaurant votes
            //            else if (nextState == AppState.Done){
            //
            //            }
            
            let savedSurveyID = SurveyID.init(id: decodedMessageStruct.surveyID)
            Survey.sharedInstance.populateSurveyID(surveyID: savedSurveyID)
            self.surveyID = savedSurveyID
            
            if(self.isLeader) {
                print(Survey.sharedInstance.toString())
            }
            
            //check if leader ... if so go to wait
            if(self.isLeader){
                
                //if survey is finished, advance to the next state
                if(Survey.sharedInstance.roundIsFinished()) {
                    Survey.sharedInstance.tallyResults(appstate: nextState)

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
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    private func instantiateInitialSetupController() -> UIViewController {
        // Instantiate a `StartMenuViewController`.
        guard let controller = storyboard?.instantiateViewController(withIdentifier: InitialSetupViewController.storyboardIdentifier)
            as? InitialSetupViewController
            else { fatalError("Unable to instantiate a StartMenuViewController from the storyboard") }
        
        controller.delegate = self
        
        return controller
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    private func instantiateStartMenuController() -> UIViewController {
        // Instantiate a `StartMenuViewController`.
        guard let controller = storyboard?.instantiateViewController(withIdentifier: MainMenuViewController.storyboardIdentifier)
            as? MainMenuViewController
            else { fatalError("Unable to instantiate a StartMenuViewController from the storyboard") }
        
        controller.delegate = self
        
        return controller
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    private func instantiateWaitingViewController() -> UIViewController {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: WaitingViewController.storyboardIdentifier)
            as? WaitingViewController
            else { fatalError("Unable to instantiate an WaitingViewController from the storyboard") }
        
        //        controller.delegate = self
        
        return controller
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
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
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    private func instantiateParticipantViewController() -> UIViewController {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: ParticipantViewController.storyboardIdentifier)
            as? ParticipantViewController
            else { fatalError("Unable to instantiate an ParticipantViewController from the storyboard") }
        
        controller.isCuisineRound = self.stateOfApp == AppState.CategorySelection
        controller.delegate = self
        
        return controller
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    private func instantiateLeaderRestaurantViewController() -> UIViewController {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: LeaderRestaurantViewController.storyboardIdentifier)
            as? LeaderRestaurantViewController
            else { fatalError("Unable to instantiate an ParticipantViewController from the storyboard") }
        
       // Survey.sharedInstance.tallyResults()
        
        controller.delegate = self
        
        return controller
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    private func instantiateDoneViewController() -> UIViewController {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: DoneViewController.storyboardIdentifier)
            as? DoneViewController
            else { fatalError("Unable to instantiate an ParticipantViewController from the storyboard") }
        
        controller.delegate = self
        
        return controller
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    private func initializeController(){
        
        removeAllChildViewControllers()
        
        /// - Tag: PresentViewController
        let controller: UIViewController
        print("state \(self.stateOfApp.rawValue)")
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
        case AppState.Done:
            controller = instantiateDoneViewController()
        default :
            //#TODO handle when a user tries to enter a survey they are not a part of
            controller = instantiateStartMenuController()
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
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    private func switchState(newState:AppState){
        self.stateOfApp = newState
        initializeController()
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    private func removeAllChildViewControllers() {
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }
    }
    
    //    //TODO: Do class init
    //    /**
    //     Initializes a new bicycle with the provided parts and specifications.
    //
    //     Description is something you might want
    //
    //     - Throws: SomeError you might want to catch
    //
    //     - parameter radius: The frame size of the bicycle, in centimeters
    //
    //     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
    //     */
    //    func addConversationDetails(dictionary : [String : String]) ->  [String : String] {
    //        var data = [String : String]()
    //        data = data.merging(dictionary, uniquingKeysWith: { (first, _) in first })
    //        guard let leader = self.leaderOfSurvey else{ fatalError("Expected leader")}
    //
    //        data[MessagesViewController.LEADER]  = leader
    //
    //        data[MessagesViewController.CURRENT_ROUND] = self.stateOfApp.NextState().rawValue
    //        self.stateOfApp = AppState.Wait
    //
    //        return data
    //    }
    
    //Cannot be reached from wait or booted screens
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    func composeMessage(with message:MessageStruct , caption: String, session: MSSession? = nil) -> MSMessage {
        
        var components = URLComponents()
        var queryItems = [URLQueryItem]()
        
        //encode message
        guard let encodedData = try? JSONEncoder().encode(message) else {fatalError("Encoding Failed")}
        let encodedDataStr = String(decoding: encodedData, as: UTF8.self)
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
    
    //TODO: Comment header
    /// Some introductory test that describes the purpose
    /// of the function.
    
    /**
     Another useful function
     - parameter alpha: Describe the alpha param
     - parameter beta: Describe the beta param
     */
    
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
        
        components.queryItems = self.appQueryItems
        
        /// - Tag: InsertMessageInConversation
        // Add the message to the conversation.
        conversation.insert(message) { error in
            if((error) != nil) {
                print("Error occured \(String(describing: error))")
            }
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
    func createMessageStruct(vote1:Vote, vote2:Vote, vote3:Vote, queryString:String?)->MessageStruct{
        let nextState = self.stateOfApp.rawValue
        
        guard let leader = self.leaderOfSurvey else {fatalError("No leader found")}
        guard let myUUID = self.myIdentifier else {fatalError("No UUID found")}
        guard let surveyID = self.surveyID else {fatalError("No survey ID found")}
        
        let message = MessageStruct.init(state: nextState, leader: leader, messageSender:myUUID.uuidString,surveyID:surveyID.id,urlQueryString : queryString,vote1: vote1, vote2: vote2, vote3: vote3)
        
        return message
    }
}

/// Extends `MessagesViewController` to conform to the `IceCreamsViewControllerDelegate` protocol.

extension MessagesViewController: InitialSetupViewControllerDelegate,LeaderVotingViewControllerDelegate,ParticipantVotingViewControllerDelegate,LeaderRestaurantViewDelegate,DoneViewDelegate {
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    func backToMainMenu() {
        stateOfApp = AppState.MainMenu
        switchState(newState: stateOfApp)
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    func addMessageToConversation(_ vote1:Vote,vote2:Vote,vote3:Vote, queryString:String?, caption:String){
        
        let message = createMessageStruct(vote1: vote1,vote2: vote2,vote3: vote3,queryString:queryString)
        createMessage(message: message,caption:caption)
        
        self.stateOfApp = AppState.Wait
        switchState(newState: self.stateOfApp)
        
        requestPresentationStyle(.compact)
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
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




