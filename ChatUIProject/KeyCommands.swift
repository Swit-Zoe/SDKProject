//
//  KeyCommands.swift
//  UIKeyCommand-Practice
//
//  Created by Zoe on 2022/01/20.
//

import Foundation
import UIKit

@objc protocol KeyCommandActionProtocol {
    @objc func pressEnter()
    @objc func pressNewLine()
    @objc func dummy()
}

enum KeyCommands: String, CaseIterable {
    
    case reactLastMessage = "reactLastMessage"
    case editLastMessage = "editLastMessage"
    case showPrevList = "showPrevList"
    case showNextList = "showNextList"
    case basicSetting = "basicSetting"
    case toggleSideMenu = "toggleSideMenu"
    case search = "search"
    case search2 = "search2"
    case channelInfo = "channelInfo"
    case quickSwitcher = "quickSwitcher"
    case newDirectMessage = "newDirectMessage"
    case showMention = "showMention"
    case showWriteModal = "showWriteModal"
    case showFavoriteList = "showFavoriteList"
    case showThread = "showThread"
    case quickSwitcher2 = "quickSwitcher2"
    case close = "close"
    case showEditingStatus = "showEditingStatus"
    case confirm = "confirm"
    case newLine = "newLine"
    case tabRight = "tabRight"
    case tabLeft = "tabLeft"
    case bold = "bold"
    case italic = "italic"
    case strike = "strike"
    
    var command: UIKeyCommand {
        
        switch self {
        
        case .confirm:
            let command = UIKeyCommand(title: self.rawValue,
                                       image: UIImage(systemName: "return"),
                                       action: #selector(KeyCommandActionProtocol.pressEnter),
                                       input: "\r",
                                       modifierFlags: [],
                                       propertyList: [], alternates: [],
                                       discoverabilityTitle: "선택 수락 / 제출 입력",
                                       attributes: [], state: .on)
            if #available(iOS 15.0, *) {
                command.wantsPriorityOverSystemBehavior = true
            } else {
                // Fallback on earlier versions
            }
            
            return command
            
        case .newLine:
            let command = UIKeyCommand(title: self.rawValue, action: #selector(KeyCommandActionProtocol.pressNewLine),
                                       input: "\r",
                                       modifierFlags: .shift,
                                       propertyList: [], alternates: [],
                                       discoverabilityTitle: "새 줄 추가",
                                       attributes: [], state: .on)
            if #available(iOS 15.0, *) {
                command.wantsPriorityOverSystemBehavior = true
            } else {
                // Fallback on earlier versions
            }
            
            return command
        
        default:
            let command = UIKeyCommand(title: self.rawValue, action: #selector(KeyCommandActionProtocol.pressNewLine),
                                       input: "\r",
                                       modifierFlags: .shift,
                                       propertyList: [], alternates: [],
                                       discoverabilityTitle: "새 줄 추가",
                                       attributes: [], state: .on)
            if #available(iOS 15.0, *) {
                command.wantsPriorityOverSystemBehavior = true
            } else {
                // Fallback on earlier versions
            }
            
            return command
        }
    }
}
