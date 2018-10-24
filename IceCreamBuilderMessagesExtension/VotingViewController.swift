//
//  VotingViewController.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by Lorne Miller on 10/3/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

import UIKit

class VotingViewController:UICollectionViewController{
    static let storyboardIdentifier = "VotingViewController"
    
    
    @IBOutlet var VotingCollectionView: UICollectionView!
    
    
    //    weak var delegate: IceCreamsViewControllerDelegate?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = RestaurantsNearby.sharedInstance.getIceCreams()?.count ?? 0
        return count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =  VotingCollectionView.dequeueReusableCell(withReuseIdentifier: VotingCell.reuseIdentifier, for: indexPath) as! VotingCell
        
        let row = indexPath.row
        guard let representedRestaurant =  RestaurantsNearby.sharedInstance.getRestaurant(row: row) else{
            return cell
        }
        cell.restaurant = representedRestaurant
        cell.thumbsUpObj = ThumbsUp.init()
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
        //85bb65
        //cell.statement3.textColor = UIColor.init(displayP3Red: 133, green: 187, blue: 101, alpha: 1.0)
        let bottomLine = "\(RestaurantsNearby.getRatingInStars(rating: representedRestaurant.rating)) "+price
        let textColor = UIColor.init(red: 133/255, green: 187/255, blue: 101/255, alpha: 1.0)
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: bottomLine)
        attributedString.setColor(color: textColor, forText: price)
        cell.statement3.attributedText = attributedString
        
        cell.thumbsUp.image = cell.thumbsUpObj?.getImage()
        //        cell.thumbsDown.image = UIImage(named: "thumbsDown_unselected.png")
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        cell.thumbsUp.isUserInteractionEnabled = true
        cell.thumbsUp.tag = indexPath.row
        cell.thumbsUp.addGestureRecognizer(tap)
        //        cell.statement3.text =
        //#TODO Remove this
        let iceCream = RestaurantIcon(restaurant:representedRestaurant,blackAndWhite:false)
        
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
        
        votingCell.thumbsUp.image = votingCell.thumbsUpObj?.switchState()
        if let selectedRestaurant = votingCell.restaurant {
            RestaurantsNearby.sharedInstance.toggleTappedRestaurant(row: indexPath.row)
            
            for restaurant in RestaurantsNearby.sharedInstance.getSelectedRestaurant(){
                print(restaurant.name)
            }
            
        }
    }
    
}

