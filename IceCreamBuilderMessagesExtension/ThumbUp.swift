//
//  ThumbUp.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by Lorne Miller on 10/21/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit
enum ThumbsUp_state: String {
    case selected,unselected
}

class ThumbsUp {

    static private var thumbsUpSelected = UIImage(named: "thumbsUp_selected.png")
    static private var thumbsUpUnselected = UIImage(named: "thumbsUp_unselected.png")
    
    private var state : ThumbsUp_state
    private var image:UIImage?
    init() {
       
        self.state = ThumbsUp_state.unselected
        self.setImage()
    }
    
    func setImage(){
        switch self.state {
            
        case ThumbsUp_state.selected:
            self.image = ThumbsUp.thumbsUpSelected
            
        case ThumbsUp_state.unselected:
            self.image = ThumbsUp.thumbsUpUnselected
            
        default:
            print("Unreachable")
        }
    }

    func switchState()->UIImage? {
        switch self.state {
        
        case ThumbsUp_state.selected:
            self.state = ThumbsUp_state.unselected
        
        case ThumbsUp_state.unselected:
            self.state = ThumbsUp_state.selected
        
        default:
            print("Unreachable")
    }
        
        self.setImage()
        return self.getImage()
    }
    
    func getImage()->UIImage?{
        return self.image
    }

}



