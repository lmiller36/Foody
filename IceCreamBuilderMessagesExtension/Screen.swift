//
//  Screen.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by user on 12/28/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit
class Screen {
    
   static let sharedInstance = Screen.init()
   

//    var screenHeight: CGFloat {
//        if UIInterfaceOrientationIsPortrait(screenOrientation) {
//            return UIScreen.mainScreen().bounds.size.height
//        } else {
//            return UIScreen.mainScreen().bounds.size.width
//        }
//    }
//    var screenOrientation: UIInterfaceOrientation {
//        return UIApplication.sharedApplication().statusBarOrientation
//    }
    
    fileprivate init(){
    }
    
    func width() -> CGFloat{
        print(UIScreen.screens)
        
            return UIScreen.main.bounds.width
    }
    
    func centerWidth() ->CGFloat{
        return UIScreen.main.bounds.width/2
    }
    
    func height()->CGFloat{
        return UIScreen.main.bounds.height

    }
    

    
    
}
