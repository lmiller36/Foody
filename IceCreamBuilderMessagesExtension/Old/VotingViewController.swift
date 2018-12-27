//
//  VotingViewController.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by Lorne Miller on 10/3/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

import UIKit
import Messages

class VotingViewController:UICollectionViewController{
    static let storyboardIdentifier = "VotingViewController"
    
    
    @IBOutlet var VotingCollectionView: UICollectionView!
    
    var appState = AppState.NotInApp

       weak var delegate: VotingMenuViewControllerDelegate?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = RestaurantsNearby.sharedInstance.getIceCreams()?.count ?? 0
        return count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: VotingHeader.reuseIdentifier, for: indexPath)
            // do any programmatic customization, if any, here
            
            return view
        }
        
        fatalError("Unexpected kind")
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =  VotingCollectionView.dequeueReusableCell(withReuseIdentifier: VotingCell.reuseIdentifier, for: indexPath) as! VotingCell
        
        let row = indexPath.row
        guard let representedRestaurant =  RestaurantsNearby.sharedInstance.getRestaurant(row: row) else{
            return cell
        }
        cell.restaurant = representedRestaurant
        cell.votingCellImage = VotingCellImage.init(appState: self.appState)
        // Use a placeholder sticker while we fetch the real one from the cache.
        let cache = IceCreamStickerCache.cache
        cell.stickerView.sticker = cache.placeholderSticker
        
        let restarauntName = representedRestaurant.name
        guard let price = representedRestaurant.price else {return cell}
        let rating = representedRestaurant.rating
        let category = representedRestaurant.categories[0].title
        let address = representedRestaurant.location.address1
        let distance =  Measurement(value: representedRestaurant.distance, unit: UnitLength.meters).converted(to: UnitLength.miles).value
        
        
        cell.labelView.textAlignment = NSTextAlignment.center
        //       cell.labelView.text = self.showDetails ? category : restarauntName
        cell.labelView.text = category
        
        
        //        let forceTouchGestureRecognizer = ForceTouchGestureRecognizer(target: self, action: #selector(forceTouchHandler))
        //
        //        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        //        cell.addGestureRecognizer(tap)
        //        cell.addGestureRecognizer(forceTouchGestureRecognizer)
        //
        //        cell.isUserInteractionEnabled = true
        cell.cellInfo.text = restarauntName;
        cell.statement1.text = (address);
        cell.statement2.text = String(format: "%.1f", distance)+" miles"

        let bottomLine = "\(RestaurantsNearby.getRatingInStars(rating: representedRestaurant.rating)) "+price
        let textColor = UIColor.init(red: 133/255, green: 187/255, blue: 101/255, alpha: 1.0)
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: bottomLine)
        attributedString.setColor(color: textColor, forText: price)
        cell.statement3.attributedText = attributedString
        
        cell.imageView.image = cell.votingCellImage?.getImage()
        //        cell.thumbsDown.image = UIImage(named: "thumbsDown_unselected.png")
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        cell.imageView.isUserInteractionEnabled = true
        cell.imageView.tag = indexPath.row
        cell.imageView.addGestureRecognizer(tap)
        //        cell.statement3.text =
        //#TODO Remove this
        let iceCream = Restaurant(restaurant:representedRestaurant,blackAndWhite:false)
        
        // Fetch the sticker for the ice cream from the cache.
        cache.sticker(for: iceCream) { sticker in
            OperationQueue.main.addOperation {
                // If the cell is still showing the same ice cream, update its sticker view.
                //                guard cell.representedIceCream == iceCream else { return }
                cell.stickerView.sticker = sticker
            }
        }
        
        return cell
        
    }
    
    @objc private func tapped(_ sender: UITapGestureRecognizer){
        
        print("tapped image!")
        
        
        guard let indexPath = self.collectionView?.indexPathForItem(at: sender.location(in: self.collectionView)) else {return}
        guard let votingCell = self.collectionView?.cellForItem(at: indexPath) as? VotingCell else {return}
        
        votingCell.imageView.image = votingCell.votingCellImage?.switchState()
        if let selectedRestaurant = votingCell.restaurant {
            RestaurantsNearby.sharedInstance.toggleTappedRestaurant(row: indexPath.row)
            print(selectedRestaurant.name)
        }
    }
    
    override func viewDidLoad() {
        //TODO SWITCH TO CACHE
        print(RestaurantsNearby.sharedInstance.getKnownRestaurants())
        print(RestaurantsNearby.sharedInstance.getIceCreams())
        print(RestaurantsNearby.sharedInstance.getVotes())
        if(RestaurantsNearby.sharedInstance.getKnownRestaurants().count == 0){
            generateNearbyRestaurants(completionHandler: { (restaurants) in
                //TODO CHECK IF HERE
                RestaurantsNearby.sharedInstance.clearAll()
                //print(RestaurantsNearby.sharedInstance.getKnownRestaurants())
                print(RestaurantsNearby.sharedInstance.getVotes())
                
                for restaurant in restaurants {
                    
                    if(RestaurantsNearby.sharedInstance.getVotesForARestaurant(id: restaurant.id) > 0)
                    {
                        print(restaurant.name)
                        RestaurantsNearby.sharedInstance.add(restaurant: restaurant)
                    }
                }
                //            guard let iceCreams = RestaurantsNearby.sharedInstance.getIceCreams() else{return}
                //            var newItems: [CollectionViewItem] = iceCreams.map { .iceCream($0) }
                //            var i = 0;
                //            // self.items.removeAll()
                //            for _ in iceCreams{
                //                self.items.append(newItems[i])
                //                i=i+1
                //            }
                //
                let nc = NotificationCenter.default
                nc.post(name: Notification.Name("DataFetched"), object: nil)
                //nc.post(name: Notification.Name("ToggleMapButton"), object: nil)
                print("posted")
                
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                    self.viewWillAppear(true)
                }
                
            })
            
        }
    }
    
    @IBAction func submitSelection(_ sender: Any) {
        let selectedRestaurants = RestaurantsNearby.sharedInstance.getSelectedRestaurant()
        print(RestaurantsNearby.sharedInstance.getKnownRestaurants())
        print(RestaurantsNearby.sharedInstance.getSelectedRestaurant())
        // 5 is an arbitrary number
        let extraneousCount = selectedRestaurants.count - 3
        
        //TODO Ensure that this works
        if(selectedRestaurants.count == 0){
            let alert = UIAlertController(title: "At least 1 suggestions must be given",message:"Please add at least 1 item", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            
            self.present(alert, animated: true)
        }
        else if(extraneousCount > 0){
            let alert = UIAlertController(title: "Up to 2 suggestions are alloted per person", message: "Please remove at least \(extraneousCount) \(extraneousCount == 1 ? "item":"items")", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            
            self.present(alert, animated: true)
        }
            
        else {
            
            let selectedIceCream = Restaurant(restaurant:selectedRestaurants[0],blackAndWhite:false)
            delegate?.changePresentationStyle(presentationStyle: .compact)
            delegate?.addMessageToConversation(selectedRestaurants,messageImage: selectedIceCream)
        }
    }
    
    
}


protocol VotingMenuViewControllerDelegate: class {
    
    
    func addMessageToConversation(_ restaurants:[RestaurantInfo],messageImage:Restaurant)
    
    func changePresentationStyle(presentationStyle:MSMessagesAppPresentationStyle)
    
}
