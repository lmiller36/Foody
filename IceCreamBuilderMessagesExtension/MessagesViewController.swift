/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 The root view controller shown by the Messages app.
 */

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    // MARK: Properties
    
    var globalStateOfApp : AppState?
    var stateOfApp = AppState.MainMenu
    var myIdentifier : UUID?
    var knownParticipants = [Participant]()
    var knownNumberOfParticipants : Int?
    
    //    var shouldStall = false
    
    public static let GLOBAL_STATE_OF_APP = "GlobalStateOfApp"
    public static let NUMBER_OF_RESTAURANTS = "NumberOfRestaurants"
    public static let NUMBER_OF_PARTICIPANTS = "NumberOfParticipants"
    public static let NUMBER_OF_VOTES = "NumberOfVotes"
    public static let STATE_OF_APP = "StateOfApp"
    
    override func willBecomeActive(with conversation: MSConversation) {
        super.willBecomeActive(with: conversation)
        
        // Present the view controller appropriate for the conversation and presentation style.
        presentViewController(for: conversation, with: presentationStyle)
    }
    
    // MARK: MSMessagesAppViewController overrides
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
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
    
    // MARK: Child view controller presentation
    
    private func presentViewController(for conversation: MSConversation, with presentationStyle: MSMessagesAppPresentationStyle) {
        
        let url = conversation.selectedMessage?.url
        RestaurantsNearby.sharedInstance.clearAll()
        //        self.stateOfApp = AppState.MainMenu
        self.knownNumberOfParticipants = conversation.remoteParticipantIdentifiers.count + 1
        print("me \(self.myIdentifier)")
        print("FRIENDS:\(self.knownParticipants)")
        print(self.stateOfApp)
        //if in wait, we already did all of this
        if self.stateOfApp != AppState.Wait {
            
            //If in loop, someone has started a survey
            if let queryItems = URLComponents(string: url?.absoluteString ?? "")?.queryItems {
                print(queryItems)
                var myPreviousStateOfApp = AppState.NotInApp
                
                self.knownParticipants = getAllParticipantUUIDStrings(queryItems: queryItems)
                
                if let knownNumberOfParticipants = queryItems.filter({$0.name == MessagesViewController.NUMBER_OF_PARTICIPANTS}).first?.value{
                    self.knownNumberOfParticipants = Int(knownNumberOfParticipants)
                }
                
                if let globalStateOfApp = queryItems.filter({$0.name == MessagesViewController.GLOBAL_STATE_OF_APP}).first?.value{
                    self.globalStateOfApp = AppState.init(rawValue: globalStateOfApp)
                }
                
                //It is at least voiting round 1 since you are in the survey
                if let storedAppState = queryItems.filter({$0.name == conversation.localParticipantIdentifier.uuidString}).first?.value
                {
                    print("STORED STATE = \(storedAppState)")
                    myPreviousStateOfApp = AppState(rawValue: storedAppState)!
                    stateOfApp = myPreviousStateOfApp.NextState()
                    
                    
                    
                    
                    
                }
                    // A survey has just been started
                else{
                    stateOfApp = AppState.InitialSelection
                }
                
                //you are not waiting
                if(stateOfApp != AppState.Wait && stateOfApp != AppState.Booted){
                    
                    guard let numberOfRestaurants = queryItems.filter({$0.name == MessagesViewController.NUMBER_OF_RESTAURANTS}).first?.value else {
                        return
                    }
                    
                    let intNumberOfRestaurants = Int(numberOfRestaurants) ?? 0
                    
                    var count = 0;
                    while(count < intNumberOfRestaurants){
                        let key = "restaurant" + String(count)
                        let restaurantInfo = queryItems.filter({$0.name == key}).first?.value ?? ""
                        let restaurantInfoData = restaurantInfo.data(using: .utf8)!
                        
                        
                        guard let restaurant = try? JSONDecoder().decode(RestaurantInfo.self, from: restaurantInfoData) else {
                            print("Error: Couldn't decode data into restaurant")
                            return
                        }
                        let numberOfVotes = Int(queryItems.filter({$0.name == restaurant.id}).first?.value ?? "0")
                        if (stateOfApp == AppState.VotingRound1 || stateOfApp == AppState.VotingRound2 || stateOfApp == AppState.VotingRound3){
                            RestaurantsNearby.sharedInstance.add(restaurant: restaurant,numVotes: numberOfVotes!)
                        }
                        else if (stateOfApp == AppState.InitialSelection) {
                            RestaurantsNearby.sharedInstance.addOtherParticipantsSelection(restaurant: restaurant,votes: numberOfVotes!)
                        }
                        count+=1
                        
                    }
                
                }
                
            }
            //        else {
            //            print("appending")
            //            self.knownParticipants.append(Participant.init(participantIdentifier: conversation.localParticipantIdentifier.uuidString, currentStage: self.stateOfApp))
            //        }
        }
        
        self.myIdentifier =  conversation.localParticipantIdentifier
        print(self.knownParticipants)
        switchState(newState: self.stateOfApp)
        
    }
    
    private func getAllParticipantUUIDStrings(queryItems:[URLQueryItem])->[Participant]{
        var known_Participants = [Participant]()
        
        if let numberOfParticipants = queryItems.filter({$0.name == MessagesViewController.NUMBER_OF_PARTICIPANTS}).first?.value {
            var count = 0
            let intNumberOfParticipants = Int(numberOfParticipants)
            while(count < intNumberOfParticipants!) {
                if let participantUUID = queryItems.filter({$0.name ==  createParticipantKey(count: count)}).first?.value{
                    if let participantState = queryItems.filter({$0.name ==  participantUUID}).first?.value {
                        let appState = AppState.init(rawValue: participantState)
                        known_Participants.append(Participant.init(participantIdentifier: participantUUID, currentStage: appState!))
                    }
                }
                count += 1
            }
        }
        
        
        return known_Participants
    }
    
    private func createParticipantKey(count:Int)->String{
        return "participantUUID_" + String(count)
    }
    
    private func instantiateInitialSelectionController() -> UIViewController {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: InitialSelectionViewController.storyboardIdentifier)
            as? InitialSelectionViewController
            else { fatalError("Unable to instantiate an IceCreamsViewController from the storyboard") }
        
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
    
    private func instantiateVotingController() -> UIViewController {
        // Instantiate a `VotingViewController`.
        guard let controller = storyboard?.instantiateViewController(withIdentifier: VotingViewController.storyboardIdentifier)
            as? VotingViewController
            else { fatalError("Unable to instantiate a CompletedIceCreamViewController from the storyboard") }
        
        return controller
    }
    
    private func instantiateWaitingViewController() -> UIViewController {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: WaitingViewController.storyboardIdentifier)
            as? WaitingViewController
            else { fatalError("Unable to instantiate an WaitingViewController from the storyboard") }
        
        //        controller.delegate = self
        
        return controller
    }
    
    //
    //    private func instantiateCompletedIceCreamController(with iceCream: RestaurantIcon) -> UIViewController {
    //        // Instantiate a `BuildIceCreamViewController`.
    //        guard let controller = storyboard?.instantiateViewController(withIdentifier: CompletedIceCreamViewController.storyboardIdentifier)
    //            as? CompletedIceCreamViewController
    //            else { fatalError("Unable to instantiate a CompletedIceCreamViewController from the storyboard") }
    //
    //        controller.iceCream = iceCream
    //
    //        return controller
    //    }
    
    private func initializeController(){
        
        removeAllChildViewControllers()
        
        /// - Tag: PresentViewController
        let controller: UIViewController
        
        switch self.stateOfApp {
        case AppState.MainMenu:
            controller = instantiateStartMenuController()
        case AppState.InitialSelection:
            controller = instantiateInitialSelectionController ()
        case AppState.VotingRound1:
            controller = instantiateVotingController()
        case AppState.VotingRound2:
            controller = instantiateVotingController()
        case AppState.VotingRound3:
            controller = instantiateVotingController()
        case AppState.Wait:
            controller = instantiateWaitingViewController()
        default :
            //#TODO handle when a user tries to enter a survey they are not a part of
            controller = instantiateStartMenuController()
            print("NOT IN APP")
        }
        
        
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
    
    // MARK: Convenience
    
    private func removeAllChildViewControllers() {
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }
    }
    
    //Cannot be reached from wait or booted screens
    func composeMessage(with restaurants: [RestaurantInfo],messageImage: Restaurant, caption: String, session: MSSession? = nil) -> MSMessage {
        
        var components = URLComponents()
        
        var queryItems = [URLQueryItem]()
        
        let encoder = JSONEncoder()
        
        
        print(self.myIdentifier)
        print(self.knownNumberOfParticipants)
        print(self.knownParticipants)
        print(self.stateOfApp)
        
        
        
        
        
        
        
        
        //        if let myIdentifier = self.myIdentifier {
        //            queryItems.append(URLQueryItem(name: myIdentifier.uuidString, value:self.stateOfApp.rawValue))
        //        }
        
        if(self.stateOfApp.Order()<=0){fatalError("\(self.stateOfApp) should never compose a message")}
        
        let votedOnRestaurants = RestaurantsNearby.sharedInstance.getVotedOnRestaurants()
            //            queryItems.append(URLQueryItem(name: MessagesViewController.STATE_OF_APP, value: AppState.VotingRound1.rawValue))
            //
        print(votedOnRestaurants)
            queryItems.append(URLQueryItem(name: MessagesViewController.NUMBER_OF_RESTAURANTS, value: String(votedOnRestaurants.count)))
            var restaurantIds =  [String]()
            var i = 0;
            for restaurant in votedOnRestaurants{
                
                
                do {
                    let data = try encoder.encode(restaurant)
                    
                    let restaurantJSON = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                    
                    let key = "restaurant" + String(i)
                    queryItems.append(URLQueryItem(name: key, value: restaurantJSON! as String))
                    let votesForRestaurant = RestaurantsNearby.sharedInstance.getVotesForARestaurant(id: restaurant.id) + 1
                    print(votesForRestaurant)
                    //queryItems.append(URLQueryItem(name: restaurant.id, value: String(votesForRestaurant)))
                    restaurantIds.append(restaurant.id)
                    
                } catch {
                    //handle error
                    print(error)
                }
                
                i+=1
            }
        print(restaurantIds)
        
        
        
        
        
        
        
        //switchState(newState: self.stateOfApp)
        
        if let myIdentifier = self.myIdentifier {
            
            if(self.knownParticipants.filter({$0.participantIdentifier == myIdentifier.uuidString}).count == 0 ){
                self.knownParticipants.append(Participant.init(participantIdentifier: myIdentifier.uuidString, currentStage: self.stateOfApp))
            }
            
            
            if(shouldUpdateParticipantsState()){
                self.stateOfApp = AppState.Wait
                
                if let globalStateOfApp = self.globalStateOfApp {
                    queryItems.append(URLQueryItem(name: MessagesViewController.GLOBAL_STATE_OF_APP, value: self.stateOfApp.NextState().rawValue))
                }
                
            }
            else {
                self.stateOfApp = AppState.Wait
                
                if let globalStateOfApp = self.globalStateOfApp {
                    queryItems.append(URLQueryItem(name: MessagesViewController.GLOBAL_STATE_OF_APP, value: globalStateOfApp.rawValue))
                }
                
            }
            
            
            
            //add to list
            
            if let knownNumberOfParticipants = self.knownNumberOfParticipants {
                queryItems.append(URLQueryItem(name: MessagesViewController.NUMBER_OF_PARTICIPANTS, value: String(knownNumberOfParticipants)))
            }
            
            
            var count = 0
            for participant in self.knownParticipants {
                queryItems.append(URLQueryItem(name: createParticipantKey(count: count), value:participant.participantIdentifier))
                
                if(participant.participantIdentifier != myIdentifier.uuidString) {
                    queryItems.append(URLQueryItem(name: participant.participantIdentifier, value:participant.currentStage.rawValue))
                }else {
                    queryItems.append(URLQueryItem(name: participant.participantIdentifier, value:self.stateOfApp.rawValue))
                    
                }
                
                count+=1
            }
            switchState(newState: self.stateOfApp)
            
            
        }
        
        
        
        
        
        print(queryItems)
        components.queryItems = queryItems
        
        
        let layout = MSMessageTemplateLayout()
        layout.image = messageImage.renderSticker(opaque: true)
        layout.caption = caption
        
        
        
        let message = MSMessage(session: session ?? MSSession())
        
        message.url = components.url!
        
        
        message.layout = layout
        
        return message
    }
    
    func shouldUpdateParticipantsState()->Bool {
        if let knownNumberOfParticipants = self.knownNumberOfParticipants {

            if(self.knownParticipants.count < knownNumberOfParticipants){
                
                return false
            }
        }
        if let myIdentifier = self.myIdentifier {
            for participant in self.knownParticipants {
                //a participant still needs to complete the round
                if(participant.participantIdentifier != myIdentifier.uuidString && participant.currentStage != AppState.Wait){ //|| participant.currentStage.NextState() == self.stateOfApp) {
                    return false
                }
            }
            
        }
        
        return true
        
        
    }
}
    
    /// Extends `MessagesViewController` to conform to the `IceCreamsViewControllerDelegate` protocol.
    
    extension MessagesViewController: IceCreamsViewControllerDelegate {
        
        func iceCreamsViewControllerDidSelectAdd(_ controller: InitialSelectionViewController) {
            
            requestPresentationStyle(.expanded)
        }
        
        func backToMainMenu() {
            
            removeAllChildViewControllers()
            
            /// - Tag: PresentViewController
            let controller: UIViewController
            
            
            controller = instantiateStartMenuController()
            
            
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
        
        
        func addMessageToConversation(_ restaurants:[RestaurantInfo], messageImage:Restaurant){
            
            guard let conversation = activeConversation else { fatalError("Expected a conversation") }
            
            
            // Update the ice cream with the selected body part and determine a caption and description of the change.
            var messageCaption: String
            
            messageCaption = NSLocalizedString("Here's a few places that look good", comment: "test")
            
            
            // Create a new message with the same session as any currently selected message.
            let message = composeMessage(with: restaurants,messageImage:messageImage , caption: messageCaption, session: conversation.selectedMessage?.session)
            
            
            
            /// - Tag: InsertMessageInConversation
            // Add the message to the conversation.
            conversation.insert(message) { error in
                if let error = error {
                    print(error)
                    
                }
            }
        }
        
        func changePresentationStyle(presentationStyle: MSMessagesAppPresentationStyle) {
            requestPresentationStyle(.compact)
        }
        
        
    }
    
    /// Extends `MessagesViewController` to conform to the `IceCreamsViewControllerDelegate` protocol.
    
    extension MessagesViewController: MainMenuViewControllerDelegate {
        
        func switchState_StartMenu(newState:AppState) {
            switchState(newState: newState)
        }
        
}




