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
    
    var availableTypes : Dictionary<String,String>
     var typeIsBlackAndWhite : Dictionary<String,Bool>
    
    required init?(coder aDecoder: NSCoder) {
        self.availableTypes=Dictionary<String,String>()
        self.typeIsBlackAndWhite=Dictionary<String,Bool>()
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
        print(availableTypes)
        print("Loaded")
        
        if let collectionView = AvailableTypes{
            collectionView.layer.borderWidth = CGFloat(1)
            collectionView.layer.borderColor = UIColor.black.cgColor
        }
        
        print(availableTypes.keys)
        print(availableTypes.keys.count)
        
        DispatchQueue.main.async {
            self.AvailableTypes.reloadData()
        }
        
    }
    
    
    
}

extension InitialSelectionHeader: UICollectionViewDataSource {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.availableTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        return dequeueIceCreamCell( at: indexPath)
        
    }
    
    
    
    private func dequeueIceCreamCell( at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = AvailableTypes.dequeueReusableCell(withReuseIdentifier: OptionCell.reuseIdentifier,
                                                            for: indexPath) as? OptionCell
            else { fatalError("Unable to dequeue am IceCreamCell") }
    

            let currentKey = Array(availableTypes.keys)[indexPath.row]
        
            let isBlackAndWhite = self.typeIsBlackAndWhite[currentKey] ?? false
            let icon = getType(type: currentKey)
            //cell.isBlackAndWhite =
        
//            cell.representedType = currentKey
//            cell.icon = getType(type: currentKey)
            cell.Name.text = availableTypes[currentKey]

        let iceCream = Restaurant(icon: icon,blackAndWhite:isBlackAndWhite)
        
       // print("\(cell.Name.text) : \(cell.isBlackAndWhite)")

        
        // cell.representedIceCream = iceCream
        
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
        
        let currentKey = Array(availableTypes.keys)[indexPath.row]
        let isBlackAndWhite = !(self.typeIsBlackAndWhite[currentKey] ?? false)
        
        self.typeIsBlackAndWhite[currentKey] = isBlackAndWhite
        
        
        let icon = getType(type: currentKey)

        let iceCream = Restaurant(icon: icon,blackAndWhite:isBlackAndWhite)

                // Fetch the sticker for the ice cream from the cache.
                IceCreamStickerCache.cache.sticker(for: iceCream) { sticker in
                    OperationQueue.main.addOperation {
                        // If the cell is still showing the same ice cream, update its sticker view.
                        //                guard cell.representedIceCream == iceCream else { return }
                        optionCell.Sticker.sticker = sticker
                    }
                }
    }
    
    
    
}

