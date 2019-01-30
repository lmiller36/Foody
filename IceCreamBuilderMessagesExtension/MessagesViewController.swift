/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 The root view controller shown by the Messages app.
 */

import UIKit
import Messages
import CloudKit
import CoreLocation
class MessagesViewController: MSMessagesAppViewController {
    
    static var presentationStyle = MSMessagesAppPresentationStyle.compact
    
    //TODO: give descriptions
    
    //    var stateOfApp = AppState.MainMenu
    //    var leaderOfSurvey : String?
    //
    //    var remainingParticipants,completedParticipants : [String]?
    //    var myIdentifier : UUID?
    //    var isLeader = false
    //    var numberOfParticipants : Int?
    //    var appQueryItems = [URLQueryItem]()
    //    var savedAppData = [String : Int]()
    
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
    //    func voteToDiningOption(vote:Vote) -> DiningOption {
    //
    //        print(RestaurantsNearby.sharedInstance.isEmpty())
    //
    //        let category = vote.cuisine
    //
    //        guard let grouping = Grouping.init(rawValue : category) else {fatalError("Unexpected grouping value")}
    //        let cuisine =  Cuisines.getCuisine(grouping: grouping)
    //
    //        let image = cuisine.displayInformation.image
    //        let diningOption = DiningOption.init(cuisine: category, image: image, restaurant: Optional<RestaurantInfo>.none)
    //
    //        return diningOption
    //    }
    
    func populateDiningOptions(messageStruct:MessageStruct){
        //
        //        guard let nextState = AppState.init(rawValue:  messageStruct.state) else {fatalError("unexpected App State")}
        //
        //
        //        if(nextState == AppState.CategorySelection) {
        //            let option1 = self.voteToDiningOption(vote: messageStruct.vote1)
        //            let option2 = self.voteToDiningOption(vote: messageStruct.vote2)
        //            let option3 = self.voteToDiningOption(vote: messageStruct.vote3)
        //
        //
        //            let leadersSelection = DiningOptions.init(option1: option1, option2: option2, option3: option3)
        //
        //            print(leadersSelection)
        //            print(nextState)
        //
        //            Survey.sharedInstance.receivedFirstRoundOptions(firstRoundOptions: leadersSelection)
        //        }
        //       else if(nextState == AppState.RestaurantSelection) {
        //            //Survey.sharedInstance.receivedSecondRoundOptions(secondRoundOptions: leadersSelection)
        //
        //            guard let id1 = messageStruct.vote1.restaurantId else {fatalError("ID missing")}
        //            guard let id2 = messageStruct.vote2.restaurantId else {fatalError("ID missing")}
        //            guard let id3 = messageStruct.vote3.restaurantId else {fatalError("ID missing")}
        //
        //            let IDs = [id1,id2,id3]
        //
        //            Survey.sharedInstance.setApprovedRestaurants(restaurantIDs: IDs)
        //
        //        }
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
        
//        if(Survey.sharedInstance.appState == AppState.Wait){
//            switchState()
//            return
//        }
        
        let url = conversation.selectedMessage?.url
        
        //self.leaderOfSurvey = conversation.localParticipantIdentifier.uuidString
        
        // go to setup if need
        if(!UserData.sharedInstance.isCacheDataAvailable()) {
            Survey.sharedInstance.appState = AppState.Setup
            switchState()
            return
        }
        
        Survey.sharedInstance.appState = AppState.MainMenu
        Survey.sharedInstance.participantUUID  = conversation.localParticipantIdentifier.uuidString
        
        //defaults to true, and changed if necessary with the message struct
        Survey.sharedInstance.isLeader  = true
        
        //defaults to number in conversation (not including the leader)
        Survey.sharedInstance.participatingMemberCount = conversation.remoteParticipantIdentifiers.count
        
        Survey.sharedInstance.participantUUID = conversation.localParticipantIdentifier.uuidString
        
        
        //there has been at least one round
        if let queryItems = URLComponents(string: url?.absoluteString ?? "")?.queryItems {
            guard let savedMessage =  queryItems.filter({$0.name == MessagesViewController.DATA}).first?.value else {fatalError("Data was not received")}
            
            guard let decodedData = savedMessage.data(using: .utf8) else {fatalError("Data could not be decoded")}
            
            guard let decodedMessageStruct = try?JSONDecoder().decode(MessageStruct.self, from: decodedData) else {fatalError("Data not sent as message struct")}
            
            Survey.sharedInstance.recordID = decodedMessageStruct.surveyID
            print(decodedMessageStruct)
            
            DispatchQueue.main.async {
                if(Survey.sharedInstance.record == nil){
                    Survey_Cloud_Model.shared_instance.getPublicRecord(recordName: decodedMessageStruct.surveyID, completion : { (record) in
                        
                        Survey.sharedInstance.record = record
                        let survey_cloud = SurveyCloud.convertRecord(record: record)
                        print(survey_cloud)
                        Survey.sharedInstance.populateSurvey(surveyCloud: survey_cloud)
                        
                        self.switchState()
                        //                    if let storedData = record["data"] {
                        //                        print(storedData)
                        //                        let storedJSON = storedData as! String
                        //                        guard let decodedData = storedJSON.data(using: .utf8) else {fatalError("Data could not be decoded")}
                        //
                        //                        guard let decodedSurvey = try?JSONDecoder().decode(SurveyCloud.self, from: decodedData) else {fatalError("Data not sent as message struct")}
                        //                        print(decodedSurvey)
                        //                        Survey.sharedInstance.populateSurvey(surveyCloud: decodedSurvey)
                        //                        self.switchState()
                        //                    }
                        
                        
                        
                        
                    })
                }
                else {
                    self.switchState()
                }
            }
        }
            //leader on first round
        else {
            Survey.sharedInstance.isLeader = true
            Survey.sharedInstance.leaderID = conversation.localParticipantIdentifier.uuidString
            
            switchState()
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
        
        //    controller.isCuisineRound = self.stateOfApp == AppState.CategorySelection
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
        print("state \(Survey.sharedInstance.appState)")
        switch Survey.sharedInstance.appState {
        case AppState.Setup :
            controller = instantiateInitialSetupController()
        case AppState.MainMenu:
            controller = instantiateStartMenuController()
        case AppState.CategorySelection:
            if(Survey.sharedInstance.isLeader){
                controller = instantiateLeaderVotingController()
            }
            else {
                controller = instantiateParticipantViewController()
            }
        case AppState.RestaurantSelection :
            if(Survey.sharedInstance.isLeader){
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
    private func switchState(){
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
        
        // components.queryItems = self.appQueryItems
        
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
    func createMessageStruct(surveyID : String) -> MessageStruct{
        
        let message = MessageStruct.init(surveyID : surveyID)
        
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
        Survey.sharedInstance.appState = AppState.MainMenu
        switchState()
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    func addMessageToConversation(caption:String){
        
        let record = Survey.sharedInstance.getRecord()
        
        Survey_Cloud_Model.shared_instance.savePublicRecord(record: record)
        
        let message = createMessageStruct(surveyID: record.recordID.recordName)
        print(message)
        createMessage(message: message,caption:caption)
        
        Survey.sharedInstance.appState = AppState.Wait
        switchState()
        
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
    
    func switchState_StartMenu() {
        switchState()
    }
    
}




