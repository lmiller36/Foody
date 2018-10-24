/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The root view controller shown by the Messages app.
*/

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {

    // MARK: Properties
    
    var stateOfApp = State.MainMenu
    
    public static var NUMBER_OF_RESTAURANTS = "NumberOfRestaurants"
     public static var STATE_OF_APP = "StateOfApp"
    
   public enum State : String{
        case MainMenu
        case InitialSelection
        case VotingRound1
        case VotingRound2
        case VotingRound3
    }
    
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
        
        let queryItems = URLComponents(string: url?.absoluteString ?? "")?.queryItems ?? nil
        
        guard let stateOfApp =  MessagesViewController.State(rawValue: queryItems?.filter({$0.name == MessagesViewController.STATE_OF_APP}).first?.value ?? State.MainMenu.rawValue) else {return}
        
        print(stateOfApp)
        
        if (stateOfApp == State.VotingRound1 || stateOfApp == State.VotingRound2 || stateOfApp == State.VotingRound3){
            guard let numberOfRestaurants = queryItems?.filter({$0.name == MessagesViewController.NUMBER_OF_RESTAURANTS}).first?.value else {
                return
            }
            
            let intNumberOfRestaurants = Int(numberOfRestaurants) ?? 0
            
            var count = 0;
            
            while(count < intNumberOfRestaurants){
                let key = "restaurant" + String(count)
                let restaurantInfo = queryItems?.filter({$0.name == key}).first?.value ?? ""
                let restaurantInfoData = restaurantInfo.data(using: .utf8)!
                
                guard let restaurant = try? JSONDecoder().decode(Restaurant.self, from: restaurantInfoData) else {
                    print("Error: Couldn't decode data into restaurant")
                    return
                }
                
                RestaurantsNearby.sharedInstance.add(restaurant: restaurant)
                
                count+=1
            }
        }
     
        switchState(newState: stateOfApp)
 
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
        case State.MainMenu:
            controller = instantiateStartMenuController()
        case State.InitialSelection:
            controller = instantiateInitialSelectionController ()
        case State.VotingRound1:
            controller = instantiateVotingController()
        case State.VotingRound2:
            controller = instantiateVotingController()
        case State.VotingRound3:
            controller = instantiateVotingController()
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
    
    private func switchState(newState:State){
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
    func composeMessage(with restaurants: [Restaurant],messageImage: RestaurantIcon, caption: String, session: MSSession? = nil) -> MSMessage {
        
        var components = URLComponents()
        
        var queryItems = [URLQueryItem]()
        
        let encoder = JSONEncoder()
        
        if(self.stateOfApp == State.InitialSelection){
            
             queryItems.append(URLQueryItem(name: MessagesViewController.STATE_OF_APP, value: State.VotingRound1.rawValue))
            
            queryItems.append(URLQueryItem(name: MessagesViewController.NUMBER_OF_RESTAURANTS, value: String(restaurants.count)))
            
            var i = 0;
            for restaurant in restaurants{
                
                
                do {
                    let data = try encoder.encode(restaurant)
                    
                    let restaurantJSON = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                    
                    let key = "restaurant" + String(i)
                    queryItems.append(URLQueryItem(name: key, value: restaurantJSON! as String))
                } catch {
                    //handle error
                    print(error)
                }
                
                i+=1
            }
        }

        
        components.queryItems = queryItems
        
        
        let layout = MSMessageTemplateLayout()
        layout.image = messageImage.renderSticker(opaque: true)
        layout.caption = caption
        
        
        
        let message = MSMessage(session: session ?? MSSession())
        
       message.url = components.url!

        
        message.layout = layout
        
        return message
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
    
    
    func addMessageToConversation(_ restaurants:[Restaurant], messageImage:RestaurantIcon){
        
        guard let conversation = activeConversation else { fatalError("Expected a conversation") }
        
        
        // Update the ice cream with the selected body part and determine a caption and description of the change.
        var messageCaption: String
        
        messageCaption = NSLocalizedString("Here's a few places that look good", comment: "")
        
        
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
    
    func switchState_StartMenu(newState:State) {
        switchState(newState: newState)
    }
    
}




