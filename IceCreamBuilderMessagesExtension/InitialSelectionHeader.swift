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

class InitialSelectionHeader: UICollectionReusableView {
    
    static let reuseIdentifier = "InitialSelectionHeaderReusableView"
    
    @IBOutlet weak var Title: UITextView!
    @IBOutlet weak var ExpandedSwitch: UISwitch!
    
    @IBOutlet weak var ExpandedSwitchDescription: UITextView!
    
    @IBOutlet weak var AvailableTypes: UICollectionView!
    
    @IBOutlet weak var MapButton: UIButton!
    
    var isMapButton:Bool
    
    var availableTypes : [RestaurantCategory]
    var typeIsBlackAndWhite : [RestaurantCategory:Bool]
    
    var items : [RestaurantCategory]
    
    required init?(coder aDecoder: NSCoder) {
        self.availableTypes = [RestaurantCategory]()
        self.typeIsBlackAndWhite = [RestaurantCategory:Bool]()
        
        self.items = [RestaurantCategory]()
        
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
        
        self.reloadData()
        
        
    }
    
    @objc func onDidReceiveData(_ notification: Notification)
    {
        
        print("received")
        availableTypes = RestaurantsNearby.sharedInstance.getApplicableRestaurantCategories()
        self.items = availableTypes
        print(availableTypes)
        print("Loaded")
        
        if let collectionView = AvailableTypes {
            collectionView.layer.borderWidth = CGFloat(1)
            collectionView.layer.borderColor = UIColor.black.cgColor
        }
        
        self.reloadData()
        
    }
    
    
    
}

extension InitialSelectionHeader: UICollectionViewDataSource {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return dequeueIceCreamCell( at: indexPath)
        
    }
    
    
    
    private func dequeueIceCreamCell( at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = AvailableTypes.dequeueReusableCell(withReuseIdentifier: OptionCell.reuseIdentifier,
                                                            for: indexPath) as? OptionCell
            else { fatalError("Unable to dequeue am IceCreamCell") }
        
        
       // let currentKey = Array(availableTypes.keys)[indexPath.row]
        let category = items[indexPath.row]
        let isBlackAndWhite = self.typeIsBlackAndWhite[category] ?? false
        let icon = getType(type: category.key)
        
        cell.Name.text = category.displayName
        
        let iceCream = Restaurant(icon: icon,blackAndWhite:isBlackAndWhite)
        
        
        // Fetch the sticker for the ice cream from the cache.
        IceCreamStickerCache.cache.sticker(for: iceCream) { sticker in
            OperationQueue.main.addOperation {
                // If the cell is still showing the same ice cream, update its sticker view.
                //                guard cell.representedIceCream == iceCream else { return }
                cell.Sticker.sticker = sticker
            }
        }
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        
        let forceTouchGestureRecognizer = ForceTouchGestureRecognizer(target: self, action: #selector(forceTouchHandler))
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTappedHandler))
        doubleTap.numberOfTapsRequired = 2
        
        singleTap.require(toFail: doubleTap)
        singleTap.delaysTouchesBegan = true
        doubleTap.delaysTouchesBegan = true
        
        cell.Sticker.isUserInteractionEnabled = true
        cell.Sticker.tag = indexPath.row
        cell.Sticker.addGestureRecognizer(singleTap)
        cell.Sticker.addGestureRecognizer(forceTouchGestureRecognizer)
        cell.Sticker.addGestureRecognizer(doubleTap)
        
        
        // cell.representedIceCream = iceCream
        // Use a placeholder sticker while we fetch the real one from the cache.
        //  let cache = IceCreamStickerCache.cache
        // cell.stickerView.sticker = cache.placeholderSticker
        
        
        
        return cell
    }
    
    @objc private func tapHandler(_ sender: UITapGestureRecognizer){
        
        
        guard let indexPath = AvailableTypes.indexPathForItem(at: sender.location(in: AvailableTypes)) else {return}



        guard let optionCell = AvailableTypes.cellForItem(at: indexPath) as? OptionCell else {return}

        let category = self.items[indexPath.row]

        let isBlackAndWhite = !(self.typeIsBlackAndWhite[category] ?? false)

        self.typeIsBlackAndWhite[category] = isBlackAndWhite

        let icon = getType(type: category.key)

        let iceCream = Restaurant(icon: icon,blackAndWhite:isBlackAndWhite)

        // Fetch the sticker for the ice cream from the cache.
        IceCreamStickerCache.cache.sticker(for: iceCream) { sticker in
            OperationQueue.main.addOperation {
                // If the cell is still showing the same ice cream, update its sticker view.
                //                guard cell.representedIceCream == iceCream else { return }
                optionCell.Sticker.sticker = sticker
            }
        }


        //hide applicable restaurants
        RestaurantsNearby.sharedInstance.toggleIgnoredStatus(ignoredType: category)
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("HideApplicableRestaurants"), object: nil)
        
    }
    
    @objc private func forceTouchHandler(_ sender: UITapGestureRecognizer){
        
        guard let indexPath = AvailableTypes.indexPathForItem(at: sender.location(in: AvailableTypes)) else {return}
        guard let optionCell = AvailableTypes.cellForItem(at: indexPath) as? OptionCell else {return}
        
        for category in self.items{
            self.typeIsBlackAndWhite[category] = false
            
            //hide applicable restaurants
            RestaurantsNearby.sharedInstance.setIgnoredStatus(ignoredType: category, status: true)
            
        }
        
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("HideApplicableRestaurants"), object: nil)
        
        self.reloadData()
        
    }
    
    
    @objc private func doubleTappedHandler(_ sender: UITapGestureRecognizer){
        
        guard let indexPath = AvailableTypes.indexPathForItem(at: sender.location(in: AvailableTypes)) else {return}
        guard let optionCell = AvailableTypes.cellForItem(at: indexPath) as? OptionCell else {return}

        for category in self.items{
            self.typeIsBlackAndWhite[category] = true

            //hide applicable restaurants
            RestaurantsNearby.sharedInstance.setIgnoredStatus(ignoredType: category, status: false)

        }

        let category = items[indexPath.row]

        RestaurantsNearby.sharedInstance.setIgnoredStatus(ignoredType: category, status: true)

        self.typeIsBlackAndWhite[category] = false

        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("HideApplicableRestaurants"), object: nil)

        self.reloadData()

        
        
    }
    
    func toggleBlackAndWhite(key:Int){
//        let currentKey = Array(availableTypes.keys)[key]
//        let isBlackAndWhite = !(self.typeIsBlackAndWhite[currentKey] ?? false)
//        self.typeIsBlackAndWhite[currentKey] = isBlackAndWhite
    }
    
    func reloadData(){
        DispatchQueue.main.async {
            self.AvailableTypes.reloadData()
        }
    }
    
//    private func updateVisibleRestaurants(restaurants:[Res]){
//        
//    }
    
    
}

