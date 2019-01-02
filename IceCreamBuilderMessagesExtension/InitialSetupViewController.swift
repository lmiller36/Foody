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
    

    override func viewDidLoad() {//        Username.on
        //Username.resignFirstResponder()
        
    }
    
    @IBAction func SubmitUserData(_ sender: Any) {
        guard let userEnteredName = Username.text else {return}
        
        //user entered some name
        if(!userEnteredName.isEmpty){
            print(userEnteredName)
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
    
    func addMessageToConversation(_ dictionary:[String:String],caption:String)
    
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
    
    func isCacheDataAvailable() -> Bool {
        return self.cacheDataAvailable
    }
    
    fileprivate static func readFromCache() -> String?{
        if Storage.fileExists(UserData.filename, in: .caches) {
            // we have messages to retrieve
            let messagesFromDisk = Storage.retrieve(UserData.filename, from: .caches, as: [Message].self)
            
            
            let username = messagesFromDisk[0].body
            return username
        }
        else{
            print("User data not in cache!")
            return Optional<String>.none
        }
        

    }
    
    func writeCache(userdata : String){
                var messages = [Message]()
        
        
                let newMessage = Message(title: "UserData", body: userdata)
                messages.append(newMessage)
                print(messages)
        
        Storage.store(messages, to: .caches, as: UserData.filename)
    }
    
    fileprivate static func writeCache() {
        
    }
}
