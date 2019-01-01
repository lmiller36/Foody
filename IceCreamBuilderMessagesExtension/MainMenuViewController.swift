//
//  MainMenuViewController.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by Lorne Miller on 10/22/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

import UIKit
import Messages
import SCSDKLoginKit


class MainMenuViewController :UIViewController{
    
  //  @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var Logo: UILabel!
    
    @IBOutlet weak var Continue: UIButton!
    @IBOutlet weak var ContinueLabel: UILabel!
    
    @IBOutlet weak var NewSurveyView: UIView!
    @IBOutlet weak var NewSurvey: UIButton!
    @IBOutlet weak var NewSurveyLabel: UILabel!
    
    
    @IBOutlet weak var HelpView: UIView!
    @IBOutlet weak var Help: UIButton!
    @IBOutlet weak var HelpLabel: UILabel!
    
    @IBOutlet weak var SettingsView: UIView!
    @IBOutlet weak var Settings: UIButton!
    @IBOutlet weak var SettingsLabel: UILabel!
    
    @IBOutlet weak var MadeByLorne: UILabel!
    weak var delegate: MainMenuViewControllerDelegate?
    
    static let storyboardIdentifier = "MainMenuViewController"
    

    
    @IBAction func LoginSnapchat(_ sender: Any) {
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
    
        //if view is compact, hide buttons
       
       let viewIsCompact = MessagesViewController.presentationStyle == MSMessagesAppPresentationStyle.compact
      
            self.NewSurveyView.isHidden = viewIsCompact
            self.SettingsView.isHidden = viewIsCompact
            self.HelpView.isHidden = viewIsCompact

            //encodeDataCheck()

    }
    
    
    
//    func encodeDataCheck(){
//
//        let now = Date()
//
//        let formatter = DateFormatter()
//
//        formatter.timeZone = TimeZone.current
//        formatter.dateFormat = "yyyy-MM-dd HH:mm.ss"
//
//        let dateString = formatter.string(from: now)
//
//
//
//
//        if Storage.fileExists("messages.json", in: .documents) {
//            // we have messages to retrieve
//            let messagesFromDisk = Storage.retrieve("messages.json", from: .documents, as: [Message].self)
//
//            print(messagesFromDisk)
//        }
//
//            var messages = [Message]()
//
//
//                let newMessage = Message(title: "Message", body: dateString)
//                messages.append(newMessage)
//
//
//            Storage.store(messages, to: .documents, as: "messages.json")
//
//
//
//        print(dateString)
//
//
////        let cache = NSCache<NSString, NSString>()
////        let myObject: NSString
////
////        if let cachedVersion = cache.object(forKey: "CachedObject") {
////            // use the cached version
////            myObject = cachedVersion
////            print("found in cache")
////        } else {
////            // create it from scratch then store in the cache
////            myObject = dateString as NSString
////            cache.setObject(dateString as NSString, forKey: "CachedObject")
////        }
////
//    }
    

    
    
    @IBAction func AddNewSurvey(_ sender: UIGestureRecognizer) {
        print("Add new survey")
        print(sender)
        delegate?.switchState_StartMenu(newState: AppState.CategorySelection)
    }
    
    
    
    
    
}

class MainMenu{
    static let headerHeight = Int(0.3 * Screen.sharedInstance.height())
    static let frameHeight = Int(Screen.sharedInstance.height()) - MainMenu.headerHeight
    static let buttonLength = Int(0.1 * Screen.sharedInstance.height())
}

class ScrollingFoodCell : UICollectionViewCell{
    static let reuseIdentifier = "ScrollingFoodCell"
    
    @IBOutlet weak var Foooood: UILabel!
    
    
}

// A delegate protocol for the `IceCreamsViewController` class

protocol MainMenuViewControllerDelegate: class {
    
    /// Called to start a new survey
    func switchState_StartMenu(newState:AppState)
    
}
