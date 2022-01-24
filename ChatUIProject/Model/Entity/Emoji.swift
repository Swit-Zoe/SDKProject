//
//  Emoji.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/24.
//

import Foundation

// MARK: - Welcome
struct Emoji: Codable {
    let name: EmojiInfo
}

// MARK: - Hash
struct EmojiInfo: Codable {
    let key, img: String
    let unicode:String
    
    enum CodingKeys: String, CodingKey {
        case unicode = "name"
        case key
        case img
    }
}
