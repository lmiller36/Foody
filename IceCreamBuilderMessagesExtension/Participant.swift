//
//  Participant.swift
//  IceCreamBuilderMessagesExtension
//
//  Created by lorne on 10/26/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

class Participant : NSObject,Comparable {

    
    
//    enum Status {
//    case Behind
//    case Equal
//    case Ahead
//    }
    
    let participantIdentifier : String //UUID STRING
    let currentStage:AppState
    
    init(participantIdentifier:String,currentStage:AppState) {
        self.participantIdentifier = participantIdentifier
        self.currentStage = currentStage
    }
    
    override var description : String {
        return "Identifier:\(participantIdentifier) Status:\(currentStage)"
    }
    
    static func < (lhs: Participant, rhs: Participant) -> Bool {
        return  lhs.currentStage.Order() < rhs.currentStage.Order()
    }
    
    static func  == (lhs: Participant, rhs: Participant) -> Bool {
       return lhs.participantIdentifier == rhs.participantIdentifier
    }
    
    func withinOneStage(participant:Participant)->Int{
        return self.currentStage.Order() - participant.currentStage.Order()
    }
}
