//
//  Emoji.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/25.
//

import Foundation
import UIKit

class EmojiUtils {
    static let shared = EmojiUtils()
    var emojiDictionary:[String:[String:String]] = [:]
    private init() {
        makeEmojiDictionary()
        
    }
    private func makeEmojiDictionary(){
        guard let fileURL = Bundle.main.url(forResource: "emoji", withExtension: "json") else { return }
        guard let data = try? Data(contentsOf: fileURL) else { return }
        
        emojiDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:[String:String]]
    }
    func getEmoji(name:String,size:Int) -> NSAttributedString{
        var name = name
        name.removeFirst()
        name.removeLast()

        guard let inner = self.emojiDictionary[name] else {
            let attachment = NSTextAttachment()
        
            attachment.image = UIImage(named: "swit")
            attachment.bounds = CGRect(x: 0, y: 0, width: size, height: size)

            let emoji = NSMutableAttributedString()
            emoji.append(NSAttributedString(attachment: attachment))
            return emoji
        }
        return NSAttributedString(string: inner["name"] ?? "").fontSize(16)
    }
    
    
}
