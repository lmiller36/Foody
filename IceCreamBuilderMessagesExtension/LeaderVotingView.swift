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
    
    var category1,category2,category3 : Icon?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        
        self.category1 = Categories.sharedInstance.removeItem(index: 0)
        self.category2 = Categories.sharedInstance.removeItem(index: 0)
        self.category3 = Categories.sharedInstance.removeItem(index: 0)
        
        setCategory1()
        setCategory2()
        setCategory3()
        
        
    }
    
    func setCategory1(){
        Icon1.image = category1?.image
        Label1.text = category1?.rawValue
    }
    func setCategory2(){
        Icon2.image = category2?.image
        Label2.text = category2?.rawValue
    }
    func setCategory3(){
        Icon3.image = category3?.image
        Label3.text = category3?.rawValue
    }
    
    @IBAction func Remove1(_ sender: Any) {
        print("here1")
        category1 = category2
        setCategory1()
        Remove2((Any).self)
    }
    
    @IBAction func Remove2(_ sender: Any) {
        print("here2")
        category2 = category3
        setCategory2()
        Remove3((Any).self)
        // Categories.sharedInstance.removeItem(index: 1)
    }
    
    @IBAction func Remove3(_ sender: Any) {
        print("here3")
        category3 = Categories.sharedInstance.removeItem(index: 0)
        Queue.reloadData()
        setCategory3()
        
    }
    
    @IBAction func SubmitSelection(_ sender: Any) {
        print("I VOTED!")
        
    }
    
    
}

extension LeaderVotingViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Categories.sharedInstance.getFilteredTypesCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return dequeueVoteCell( at: indexPath)
        
    }
    
    
    
    private func dequeueVoteCell( at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = Queue.dequeueReusableCell(withReuseIdentifier: VoteCell.reuseIdentifier,
                                                   for: indexPath) as? VoteCell
            else { fatalError("Unable to dequeue a VoteCell") }
        
        let row = indexPath.row
        let representedType =  Categories.sharedInstance.getFilteredTypes()[row]
        
        cell.food_icon.image = representedType.image
        cell.label.text = representedType.rawValue
        
        return cell
    }
}

protocol LeaderVotingViewControllerDelegate: class {
    
    /// Called when a user choses to add a new `IceCream` in the `IceCreamsViewController`.
    
    func backToMainMenu()
    
    func addMessageToConversation(_ restaurants:[RestaurantInfo],messageImage:Restaurant)
    
    func changePresentationStyle(presentationStyle:MSMessagesAppPresentationStyle)
    
}
