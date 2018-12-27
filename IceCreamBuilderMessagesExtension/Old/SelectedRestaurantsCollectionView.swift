////
////  SelectedRestaurantsCollectionView.swift
////  IceCreamBuilderMessagesExtension
////
////  Created by Lorne Miller on 10/2/18.
////  Copyright © 2018 Apple. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class SelectedRestaurants:UICollectionView, UICollectionViewDataSource{
//    
//    private var items: [RestaurantCell]
//    
//    required init?(coder aDecoder: NSCoder) {
//        
////  let string = ["1","2"]
////        var items: [RestaurantCell] = string.map { }
//        
//        self.items=[RestaurantCell]()
////        items.append()
//        
//        super.init(coder: aDecoder)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//       return items.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let item = items[indexPath.row]
//        
//        // The item's type determines which type of cell to return.
// 
//   
//            return dequeueIceCreamCell(for: "iceCream", at: indexPath)
//            
//     
//    }
//    
//    private func dequeueIceCreamCell(for iceCream: String, at indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = self.dequeueReusableCell(withReuseIdentifier: InitialSelectionCell.reuseIdentifier,
//                                                             for: indexPath) as? InitialSelectionCell
//            else { fatalError("Unable to dequeue am IceCreamCell") }
//        
//        
//        return cell
//    }
//    
//    
//    
// 
//    
//    
//}
