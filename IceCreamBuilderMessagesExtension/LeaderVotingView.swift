//
//  LeaderVotingView.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by user on 12/26/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit
import Messages

class LeaderVotingViewController:UIViewController{
    static let storyboardIdentifier = "LeaderVotingViewController"
    
    @IBOutlet weak var Icon1: UIImageView!
    @IBOutlet weak var Icon2: UIImageView!
    @IBOutlet weak var Icon3: UIImageView!
    
    
    @IBOutlet weak var Label1: UILabel!
    @IBOutlet weak var Label2: UILabel!
    @IBOutlet weak var Label3: UILabel!
    
    
    @IBOutlet weak var Queue: UICollectionView!
    
    weak var delegate: LeaderVotingViewControllerDelegate?
    
    
    
    var category1,category2,category3 : RestaurantGroup?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        loadAll()
    }
    
    func loadAll(){
        self.category1 = Categories.sharedInstance.removeItem(index: 0)
        self.category2 = Categories.sharedInstance.removeItem(index: 0)
        self.category3 = Categories.sharedInstance.removeItem(index: 0)
        
        setCategory1()
        setCategory2()
        setCategory3()
        
    }
    
    func setCategory1(){
        Icon1.image = category1?.displayIcon.image
        Label1.text = category1?.grouping.rawValue
    }
    func setCategory2(){
        Icon2.image = category2?.displayIcon.image
        Label2.text = category2?.grouping.rawValue
    }
    func setCategory3(){
        Icon3.image = category3?.displayIcon.image
        Label3.text = category3?.grouping.rawValue
    }
    
    @IBAction func Remove1(_ sender: Any) {
        if(Categories.sharedInstance.getAvailableRestaurauntGroupsCount() > 0 ) {
            print("here1")
            category1 = category2
            setCategory1()
            Remove2((Any).self)
        }
    }
    
    @IBAction func Remove2(_ sender: Any) {
        if(Categories.sharedInstance.getAvailableRestaurauntGroupsCount() > 0) {
            print("here2")
            category2 = category3
            setCategory2()
            Remove3((Any).self)
            // Categories.sharedInstance.removeItem(index: 1)
        }
    }
    
    @IBAction func Remove3(_ sender: Any) {
        if(Categories.sharedInstance.getAvailableRestaurauntGroupsCount() > 0) {
            print("here3")
            category3 = Categories.sharedInstance.removeItem(index: 0)
           
            setCategory3()
        }
        
    }
    
    
    
    @IBAction func SubmitSelection(_ sender: Any) {
        let dict = ["1" : Label1.text,"2" : Label2.text, "3" :Label3.text]
        delegate?.addMessageToConversation(dict as! [String : String],caption: "Here's what Paul is in the mood for")
    }
    
    @IBAction func Swap12(_ sender: Any) {
        let temp = category1
        category1 = category2
        category2 = temp
        setCategory1()
        setCategory2()
    }
    
    
    @IBAction func Swap23(_ sender: Any) {
        let temp = category2
        category2 = category3
        category3 = temp
        setCategory2()
        setCategory3()
        
    }
    
    
    @IBAction func Shuffle(_ sender: Any) {
        Categories.sharedInstance.shuffle()
        loadAll()
       
    }
}



protocol LeaderVotingViewControllerDelegate: class {
    
    /// Called when a user choses to add a new `IceCream` in the `IceCreamsViewController`.
    
    func backToMainMenu()
    
    func addMessageToConversation(_ dictionary:[String:String],caption:String)
    
    func changePresentationStyle(presentationStyle:MSMessagesAppPresentationStyle)
    
}


