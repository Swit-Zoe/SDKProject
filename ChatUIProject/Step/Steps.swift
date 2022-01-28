//
//  ChatStep.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/26.
//

import Foundation
import RxFlow

enum FlowStep: Step{
    case toLogin
    case toDashboard
    
    case toHome
    case toTemp
    
    case toChatList
    case toProjectList
    
    case toInChat(withChannelID:Int)
    case toInChatComment(withMessageID:Int)
}
