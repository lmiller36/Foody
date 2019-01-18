//
//  AppState.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by lorne on 10/26/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

//TODO: header
enum AppState : String {
    case NotInApp
    case Setup
    case MainMenu
    case CategorySelection
    case RestaurantSelection
    case Done
    case Wait
    case Booted
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    func Order()->Int {
        switch self {
        case .Setup : return 0
        case .NotInApp: return 0
        case .MainMenu: return 0
        case .CategorySelection: return 1
        case .RestaurantSelection: return 2
        case .Done: return 5
        case .Wait: return -1
        case .Booted: return -1
        }
    }
    
    //TODO: Do class init
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     Description is something you might want
     
     - Throws: SomeError you might want to catch
     
     - parameter radius: The frame size of the bicycle, in centimeters
     
     - Returns: A beautiful, brand-new bicycle, custom-built just for you.
     */
    func NextState() ->AppState {

        switch self {
        
        case .NotInApp: return .MainMenu
        case .Setup: return .MainMenu
        case .MainMenu: return .CategorySelection
        case .CategorySelection: return .RestaurantSelection
        case .RestaurantSelection: return .Done
        case .Wait: return .Wait
        case .Done: return .Done
        case .Booted: return .Booted
        }
    }
}


