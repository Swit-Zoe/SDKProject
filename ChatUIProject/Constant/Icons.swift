//
//  Images.swift
//  ChatUIProject
//
//  Created by Zoe on 2022/01/18.
//

import Foundation
import UIKit

struct Icons {
    
    static let errIcon = UIImage()
    
    enum Priority: String {
        case highest = "Highest"
        case high = "High"
        case normal = "Normal"
        case low = "Low"
        case lowest = "Lowest"
        
        var image: UIImage {
            switch self {
            case .highest: return UIImage(named: "PriorityHighest")!
            case .high: return UIImage(named: "PriorityHigh")!
            case .normal: return UIImage(named: "PriorityNormal")!
            case .low: return UIImage(named: "PriorityLow")!
            case .lowest: return UIImage(named: "PriorityLowest")!
            }
        }
    }
    
    enum Status: String {
        case todo = "Todo"
        case doing = "Doing"
        case done = "Done"
        
        var image: UIImage {
            switch self {
            case .todo: return UIImage(named: "StatusTodo")!
            case .doing: return UIImage(named: "StatusDoing")!
            case .done: return UIImage(named: "StatusDone")!
            }
        }
    }
}
