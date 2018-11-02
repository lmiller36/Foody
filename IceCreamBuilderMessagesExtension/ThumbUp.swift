//
//  ThumbUp.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by Lorne Miller on 10/21/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit
enum ImageState: String {
    case selected,unselected
}

class VotingCellImage {

    static private var thumbsUpSelected = UIImage(named: "thumbsUp_selected.png")
    static private var thumbsUpUnselected = UIImage(named: "thumbsUp_unselected.png")
    
    static private var heartSelected = UIImage(named: "heart_selected.png")
    static private var heartUnselected = UIImage(named: "heart_unselected.png")
    
    private var imageState : ImageState
    private var appState : AppState
    private var image:UIImage?
    init(appState:AppState) {
       
        self.appState = appState
        self.imageState = ImageState.unselected
        self.setImage()
    }
    
    func setImage(){
        switch (self.imageState,self.appState) {
            
        case (ImageState.selected,AppState.VotingRound1):
           self.image = VotingCellImage.thumbsUpSelected
        case (ImageState.unselected,AppState.VotingRound1):
            self.image = VotingCellImage.thumbsUpUnselected
        
        case (ImageState.selected,AppState.VotingRound2):
            self.image = VotingCellImage.heartSelected
        case (ImageState.unselected,AppState.VotingRound2):
            self.image = VotingCellImage.heartUnselected
//
//        case (Image_state.selected,AppState.VotingRound3):
//            self.image = VotingCellImage.thumbsUpSelected
//        case (Image_state.unselected,AppState.VotingRound3):
//            self.image = VotingCellImage.thumbsUpSelected
            
        default:
            print("Unreachable")
        }
    }

    func switchState()->UIImage? {
        switch self.imageState {
        
        case ImageState.selected:
            self.imageState = ImageState.unselected
        
        case ImageState.unselected:
            self.imageState = ImageState.selected
    }
        
        self.setImage()
        return self.getImage()
    }
    
    func getImage()->UIImage?{
        return self.image
    }

}



