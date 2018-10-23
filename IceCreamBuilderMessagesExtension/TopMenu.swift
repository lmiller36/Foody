//
//  TopMenu.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by Lorne Miller on 9/26/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

import UIKit
import Messages

class TopMenu: UICollectionReusableView {

    
    
    static let reuseIdentifier = "TopMenuReusableView"
    
    @IBOutlet weak var Title: UITextView!
    @IBOutlet weak var ExpandedSwitch: UISwitch!
    
    @IBOutlet weak var ExpandedSwitchDescription: UITextView!
    
    @IBOutlet weak var AvailableTypes: UICollectionView!
    
    @IBOutlet weak var MapButton: UIButton!
    
    var isMapButton:Bool
    
    var availableTypes : Dictionary<String,String>
    
    required init?(coder aDecoder: NSCoder) {
        self.availableTypes=Dictionary<String,String>()
        self.isMapButton = true
        super.init(coder: aDecoder)
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(onDidReceiveData), name: Notification.Name(rawValue:"DataFetched"), object: nil)
        nc.addObserver(self, selector: #selector(toggleMapButton), name: Notification.Name(rawValue:"ToggleMapButton"), object: nil)

        
    }
    
    @objc func toggleMapButton(_ notification: Notification)
    {

       
        self.isMapButton = !self.isMapButton
        if(self.isMapButton){
            MapButton.setImage(UIImage(named: "map.png"), for: .normal)

        }
        else{
            MapButton.setImage(UIImage(named: "list.png"), for: .normal)
            
        }
        
        DispatchQueue.main.async {
            self.AvailableTypes.reloadData()
        }
        

    }
    
    @objc func onDidReceiveData(_ notification: Notification)
    {
        print("received")
        availableTypes = RestaurantsNearby.sharedInstance.getApplicableRestaurantCategories()
        print("Loaded")
        
        if let collectionView = AvailableTypes{
            collectionView.layer.borderWidth = CGFloat(1)
            collectionView.layer.borderColor = UIColor.black.cgColor
        }
     
        
        DispatchQueue.main.async {
            self.AvailableTypes.reloadData()
        }
        
        
//        if let data = notification.userInfo as? [String: Int]
//        {
//            //            for (name, score) in data
//            //            {
//            //                print("\(name) scored \(score) points!")
//            //            }
//        }
    }



}

extension TopMenu: UICollectionViewDataSource {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return availableTypes.keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let restaurantType = Base.all[indexPath.row].rawValue
        
        return dequeueIceCreamCell(for: restaurantType, at: indexPath)
        
    }
    
    
    
    private func dequeueIceCreamCell(for restaurantType: String, at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = AvailableTypes.dequeueReusableCell(withReuseIdentifier: OptionCell.reuseIdentifier,
                                                             for: indexPath) as? OptionCell
            else { fatalError("Unable to dequeue am IceCreamCell") }
        
        let currentKey = Array(availableTypes.keys)[indexPath.row]
        
        cell.Name.text = availableTypes[currentKey]
        
        let iceCream = IceCream(base: getType(type:currentKey), scoops: .scoops01, topping: .topping01,restaraunt:nil,blackAndWhite:false)
        
        cell.representedIceCream = iceCream
        
        // Fetch the sticker for the ice cream from the cache.
        IceCreamStickerCache.cache.sticker(for: iceCream) { sticker in
            OperationQueue.main.addOperation {
                // If the cell is still showing the same ice cream, update its sticker view.
                //                guard cell.representedIceCream == iceCream else { return }
                cell.Sticker.sticker = sticker
            }
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
       
        cell.Sticker.isUserInteractionEnabled = true
        cell.Sticker.tag = indexPath.row
        cell.Sticker.addGestureRecognizer(tap)
        
        
        
        // cell.representedIceCream = iceCream
        // Use a placeholder sticker while we fetch the real one from the cache.
        //  let cache = IceCreamStickerCache.cache
        // cell.stickerView.sticker = cache.placeholderSticker
        
        
        
        return cell
    }
    
    @objc private func tapped(_ sender: UITapGestureRecognizer){
        
   
        
        guard let indexPath = AvailableTypes.indexPathForItem(at: sender.location(in: AvailableTypes)) else {return}
        guard let optionCell = AvailableTypes.cellForItem(at: indexPath) as? OptionCell else {return}
        
        
        if let representedIceCream = optionCell.representedIceCream {
        
        let iceCream = IceCream(iceCream: representedIceCream,blackAndWhite: !representedIceCream.blackAndWhite)
        optionCell.representedIceCream = iceCream
        // Fetch the sticker for the ice cream from the cache.
        IceCreamStickerCache.cache.sticker(for: iceCream) { sticker in
            OperationQueue.main.addOperation {
                // If the cell is still showing the same ice cream, update its sticker view.
                //                guard cell.representedIceCream == iceCream else { return }
                optionCell.Sticker.sticker = sticker
            }
        }
        
            
        //let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
//        optionCell.Sticker.isUserInteractionEnabled = true
//        optionCell.Sticker.tag = indexPath.row
//        optionCell.Sticker.addGestureRecognizer(tap)
        
        
//        optionCell.layer.borderWidth = CGFloat(1)
//        optionCell.layer.borderColor = UIColor.black.cgColor
        //optionCell.
    }
    }
    


}

