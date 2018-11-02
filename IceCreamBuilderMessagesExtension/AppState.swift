//
//  AppState.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by lorne on 10/26/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

//struct StateInfo {let name:String, position:Int}

enum AppState : String {
    case NotInApp
    case MainMenu
    case InitialSelection
    case VotingRound1
    case VotingRound2
    case VotingRound3
    case Done
    case Wait
    case Booted
    
    func Order()->Int {
        switch self {
        case .NotInApp: return 0
        case .MainMenu: return 0
        case .InitialSelection: return 1
        case .VotingRound1: return 2
        case .VotingRound2: return 3
        case .VotingRound3: return 4
        case .Done: return 5
        case .Wait: return -1
        case .Booted: return -1
        }
    }
    
    func NextState() ->AppState {

        switch self {
        
        case .NotInApp: return .MainMenu
        case .MainMenu: return .InitialSelection
        case .InitialSelection: return .VotingRound1
        case .VotingRound1: return .VotingRound2
        case .VotingRound2: return .VotingRound3
        case .VotingRound3: return .Done
        case.Wait: return .Wait
        case .Done: return .Done
        case .Booted: return .Booted
        }
    }
}


