//
//  SnapchatViewController.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by user on 1/1/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation


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
import SCSDKLoginKit
import SCSDKBitmojiKit

class SnapchatViewController : UIViewController,SCSDKBitmojiStickerPickerViewControllerDelegate {
    func bitmojiStickerPickerViewController(_ stickerPickerViewController: SCSDKBitmojiStickerPickerViewController, didSelectBitmojiWithURL bitmojiURL: String, image: UIImage?) {
        print("here")
    }
    
    
    @IBOutlet weak var SnapchatView: UIView!
    static let storyboardIdentifier = "SnapchatViewController"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func SnapchatLogin(_ sender: Any) {
        print("doing something")

       fetchSnapUserInfo()
        let loginButton = SCSDKLoginButton() { (success : Bool, error : Error?) in
            // do something
            print("doing something2")

                            if let error = error {
                                print(error.localizedDescription)
                                return
                            }
            
                            if success {
                                print("success!")
                                self.fetchSnapUserInfo()
                               // fetchSnapUserInfo()
                                //SnapchatView.fetchSnapUserInfo() //example code
                            }
                        }
        }
//        SCSDKLoginClient.login(from: self, completion: { success, error in
//
//                if let error = error {
//                    print(error.localizedDescription)
//                    return
//                }
//
//                if success {
//                    print("success!")
//                    self.fetchSnapUserInfo()
//                   // fetchSnapUserInfo()
//                    //SnapchatView.fetchSnapUserInfo() //example code
//                }
//            })

    
    
    
    @IBAction func Button2(_ sender: Any) {
        self.fetchSnapUserInfo()
        SCSDKBitmojiClient.fetchAvatarURL { (avatarURL: String?, error: Error?) in
            print(error)
            print(avatarURL)
        }
    }
    
    
    private func fetchSnapUserInfo(){
        let graphQLQuery = "{me{displayName, bitmoji{avatar}}}"
        
        let variables = ["page": "bitmoji"]
        
        SCSDKLoginClient.fetchUserData(withQuery: graphQLQuery, variables: variables, success: { (resources: [AnyHashable: Any]?) in
            guard let resources = resources,
                let data = resources["data"] as? [String: Any],
                let me = data["me"] as? [String: Any] else { return }
            
            let displayName = me["displayName"] as? String
            var bitmojiAvatarUrl: String?
            if let bitmoji = me["bitmoji"] as? [String: Any] {
                bitmojiAvatarUrl = bitmoji["avatar"] as? String
            }
        }, failure: { (error: Error?, isUserLoggedOut: Bool) in
            // handle error
        })
    }
    
    override func viewDidLoad() {
        let loginButton = SCSDKLoginButton()
        
        SCSDKBitmojiClient.fetchAvatarURL { (avatarURL: String?, error: Error?) in
            print(error)
            print(avatarURL)
        }
        
        //        Username.on
        //Username.resignFirstResponder()
        
//        let stickerPickerVC = SCSDKBitmojiStickerPickerViewController()
//        stickerPickerVC.delegate = self
//        addChildViewController(stickerPickerVC)
//        view.addSubview(stickerPickerVC.view)
//        stickerPickerVC.didMove(toParentViewController: self)
        
//        let iconView = SCSDKBitmojiIconView()
//        SCSDKBitmojiClient.fetchAvatarURL { (avatarURL: String?, error: Error?) in
//            // do something
//            print("inside fetch")
//            print(avatarURL)
//        }
        
    }

    
}


//// A delegate protocol for the `IceCreamsViewController` class
//
//protocol InitialSetupViewControllerDelegate: class {
//
//    func backToMainMenu()
//
//    func addMessageToConversation(_ dictionary:[String:String],caption:String)
//
//    func changePresentationStyle(presentationStyle: MSMessagesAppPresentationStyle)
//
//}
//
