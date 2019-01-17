//
//  InitialSetupViewController.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by user on 1/1/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit
import Messages
class InitialSetupViewController : UIViewController {
    
    static let storyboardIdentifier = "InitialSetupViewController"
    @IBOutlet weak var Username: UsertextField!
    
    weak var delegate: InitialSetupViewControllerDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    @IBAction func SubmitUserData(_ sender: Any) {
        guard let userEnteredName = Username.text else {return}
        
        //user entered some name
        if(!userEnteredName.isEmpty){
            UserData.sharedInstance.writeCache(userdata: userEnteredName)
            delegate?.backToMainMenu()
        }
    }
}

class UsertextField : UITextView,UITextViewDelegate {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text as NSString).rangeOfCharacter(from: CharacterSet.newlines).location == NSNotFound {
            return true
        }
        self.resignFirstResponder()
        return false
    }
    
}

// A delegate protocol for the `IceCreamsViewController` class

protocol InitialSetupViewControllerDelegate: class {
    
    func backToMainMenu()
    func changePresentationStyle(presentationStyle: MSMessagesAppPresentationStyle)
    
}



class UserData {
    static let sharedInstance = UserData.init()
    static let filename = "UserData.json"
    let usersName : String?
    private var cacheDataAvailable : Bool
    
    fileprivate init() {
        self.usersName = UserData.readFromCache()
        self.cacheDataAvailable = self.usersName != nil
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    func isCacheDataAvailable() -> Bool {
        return self.cacheDataAvailable
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    fileprivate static func readFromCache() -> String?{
        if Storage.fileExists(UserData.filename, in: .caches) {
            
            // we have messages to retrieve
            let messagesFromDisk = Storage.retrieve(UserData.filename, from: .caches, as: [Message].self)
            
            
            let username = messagesFromDisk[0].body
            return username
        }
        else{
            return Optional<String>.none
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
    func writeCache(userdata : String){
        
        var messages = [Message]()
        let newMessage = Message(title: "UserData", body: userdata)
        messages.append(newMessage)
        
        Storage.store(messages, to: .caches, as: UserData.filename)
    }
}
