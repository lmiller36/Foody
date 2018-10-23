/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The root view controller shown by the Messages app.
*/

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {

    // MARK: Properties
    
    enum State : String{
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
        // Remove any child view controllers that have been presented.
        removeAllChildViewControllers()
        
        /// - Tag: PresentViewController
        let controller: UIViewController
  
        let url = conversation.selectedMessage?.url
        RestaurantsNearby.sharedInstance.clearAll()
//
//        if let selectedMessage = conversation.selectedMessage {
//            if url = selectedMessage.url{
//                print(url)
//            }
//            else{
//                print("no url")
//
//            }
//        } else {
//            print("no selected message")
//        }
//
   
        
//        guard let sentData = conversation.selectedMessage?.url? else { return }
//
    
        
      
        
        
        if(url != nil){
         
            let queryItems = URLComponents(string: url?.absoluteString ?? "")?.queryItems
         
           // let votingRound = queryItems?.filter({$0.name == "VotingRound"}).first
            guard let votingRound = queryItems?.filter({$0.name == "VotingRound"}).first?.value else {
                return
            }
            
             let intVotingRound = Int(votingRound) ?? 0
            
           // let param1 = queryItems?.filter({$0.name == "NumberOfRestaurants"}).first
            guard let numberOfRestaurants = queryItems?.filter({$0.name == "NumberOfRestaurants"}).first?.value else {
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
            controller = instantiateVotingController()
            
//            guard let businesses = try? JSONDecoder().decode(Restaurant.self, from: url) else {
//                print("Error: Couldn't decode data into businesses because of \(error)")
//                return
//            }
        }
        else{
            controller = instantiateStartMenuController()
          //  controller = instantiateIceCreamsController()

        }
   
        print("presentation style presentviewController")
        print(presentationStyle == .compact)
        
      //  if presentationStyle == .compact {
            // Show a list of previously created ice creams.
        
        
        //
//        } else {
//             // Parse an `IceCream` from the conversation's `selectedMessage` or create a new `IceCream`.
//            let iceCream = IceCream(message: conversation.selectedMessage) ?? IceCream()
//
//            // Show either the in process construction process or the completed ice cream.
//            if iceCream.isComplete {
//                controller = instantiateCompletedIceCreamController(with: iceCream)
//            } else {
//                controller = instantiateBuildIceCreamController(with: iceCream)
//            }
        //}

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
    
//    private func instantiatePopOverViewController() -> UIViewController {
//        guard let controller = storyboard?.instantiateViewController(withIdentifier: IceCreamsViewController.storyboardIdentifier)
//            as? IceCreamsViewController
//            else { fatalError("Unable to instantiate an IceCreamsViewController from the storyboard") }
//        
//        controller.delegate = self
//        
//        return controller
//    }
    
    private func instantiateIceCreamsController() -> UIViewController {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: InitialSelectionViewController.storyboardIdentifier)
            as? InitialSelectionViewController
            else { fatalError("Unable to instantiate an IceCreamsViewController from the storyboard") }
        
        controller.delegate = self
        
        return controller
    }
    
//    private func instantiateBuildIceCreamController(with iceCream: IceCream) -> UIViewController {
//        guard let controller = storyboard?.instantiateViewController(withIdentifier: BuildIceCreamViewController.storyboardIdentifier)
//            as? BuildIceCreamViewController
//            else { fatalError("Unable to instantiate a BuildIceCreamViewController from the storyboard") }
//        
//        controller.iceCream = iceCream
//        controller.delegate = self
//        
//        return controller
//    }
    
    
    private func instantiateStartMenuController() -> UIViewController {
        // Instantiate a `StartMenuViewController`.
        guard let controller = storyboard?.instantiateViewController(withIdentifier: StartMenuViewController.storyboardIdentifier)
            as? StartMenuViewController
            else { fatalError("Unable to instantiate a StartMenuViewController from the storyboard") }
        
        //        controller.iceCream = iceCream
          controller.delegate = self
        
        return controller
    }
    
    private func instantiateVotingController() -> UIViewController {
        // Instantiate a `BuildIceCreamViewController`.
        guard let controller = storyboard?.instantiateViewController(withIdentifier: VotingViewController.storyboardIdentifier)
            as? VotingViewController
            else { fatalError("Unable to instantiate a CompletedIceCreamViewController from the storyboard") }
        
//        controller.iceCream = iceCream
        
        return controller
    }
    
    private func instantiateCompletedIceCreamController(with iceCream: IceCream) -> UIViewController {
        // Instantiate a `BuildIceCreamViewController`.
        guard let controller = storyboard?.instantiateViewController(withIdentifier: CompletedIceCreamViewController.storyboardIdentifier)
            as? CompletedIceCreamViewController
            else { fatalError("Unable to instantiate a CompletedIceCreamViewController from the storyboard") }

        controller.iceCream = iceCream

        return controller
    }
    
    // MARK: Convenience
    
    private func removeAllChildViewControllers() {
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }
    }
    
//    /// - Tag: ComposeMessage
//     func composeMessage(with iceCream: IceCream, caption: String, session: MSSession? = nil) -> MSMessage {
//        print("consider me composed")
//        var components = URLComponents()
//        components.queryItems = iceCream.queryItems
//
//        let layout = MSMessageTemplateLayout()
//        layout.image = iceCream.renderSticker(opaque: true)
//        layout.caption = caption
//
//        print("gosh, I've been clicked")
//
//        let message = MSMessage(session: session ?? MSSession())
//        message.url = components.url!
//        message.layout = layout
//
//        return message
//    }
//
//    func addMessageToConversation(iceCream:IceCream){
//
//        guard let conversation = activeConversation else { fatalError("Expected a conversation") }
//
//
//        // Update the ice cream with the selected body part and determine a caption and description of the change.
//        var messageCaption: String
//
//            messageCaption = NSLocalizedString("Test Msg", comment: "")
//
//
//        // Create a new message with the same session as any currently selected message.
//                let message = composeMessage(with: iceCream, caption: messageCaption, session: conversation.selectedMessage?.session)
//
//        print("Im actually over here!")
//
//        /// - Tag: InsertMessageInConversation
//        // Add the message to the conversation.
//                conversation.insert(message) { error in
//                    if let error = error {
//                        print(error)
//                    }
//                }
//    }
    
    func composeMessage(with restaurants: [Restaurant],messageImage: IceCream, caption: String, session: MSSession? = nil) -> MSMessage {
        
        
//        let size = URLQueryItem(name: "Size", value: "Large")
//
//
        
        var components = URLComponents()
        
        var queryItems = [URLQueryItem]()
        
        let encoder = JSONEncoder()
      
        queryItems.append(URLQueryItem(name: "NumberOfRestaurants", value: String(restaurants.count)))
        
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
          
            
           
//
//             queryItems.append(URLQueryItem(name: "RestaurantJson", value: RestaurantsNearby.sharedInstance.getOriginalJson()))
            i+=1
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
    
    
    func addMessageToConversation(_ restaurants:[Restaurant], messageImage:IceCream){
        
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
    
    
}

/// Extends `MessagesViewController` to conform to the `IceCreamsViewControllerDelegate` protocol.

extension MessagesViewController: StartMenuViewControllerDelegate {
    
    func StartSurvey() {
        print("Start survey!")
        
        removeAllChildViewControllers()
        
        /// - Tag: PresentViewController
        let controller: UIViewController
        
       
             controller = instantiateIceCreamsController()
            
        
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
    
}


/// Extends `MessagesViewController` to conform to the `BuildIceCreamViewControllerDelegate` protocol.

extension MessagesViewController: BuildIceCreamViewControllerDelegate {

    func buildIceCreamViewController(_ controller: BuildIceCreamViewController, didSelect iceCreamPart: IceCreamPart) {
        guard let conversation = activeConversation else { fatalError("Expected a conversation") }
        guard var iceCream = controller.iceCream else { fatalError("Expected the controller to be displaying an ice cream") }

        // Update the ice cream with the selected body part and determine a caption and description of the change.
        var messageCaption: String
        if let base = iceCreamPart as? Base {
            iceCream.base = base
            messageCaption = NSLocalizedString("Let's build an ice cream", comment: "")
        } else if let scoops = iceCreamPart as? Scoops {
            iceCream.scoops = scoops
            messageCaption = NSLocalizedString("I added some scoops", comment: "")
        } else if let topping = iceCreamPart as? Topping {
            iceCream.topping = topping
            messageCaption = NSLocalizedString("Our finished ice cream", comment: "")
        } else {
            fatalError("Unexpected type of ice cream part selected.")
        }

        // Create a new message with the same session as any currently selected message.
//        let message = composeMessage(with: iceCream, caption: messageCaption, session: conversation.selectedMessage?.session)

        print("Im actually over here!")
        
        /// - Tag: InsertMessageInConversation
        // Add the message to the conversation.
//        conversation.insert(message) { error in
//            if let error = error {
//                print(error)
//            }
//        }

        // If the ice cream is complete, save it in the history.
//        if iceCream.isComplete {
//  
//            var history = IceCreamHistory.load()
//           
//                history.append(iceCream)
//
//           history.save()
//            
//        }
        
    
        
        
        
       dismiss()
    }
    
}




