//
//  Emoji.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/25.
//

import Foundation
import UIKit
import Streamoji
import Lottie

class EmojiUtils {
    static let shared = EmojiUtils()
    
    static let exampleEmojis: [String: EmojiSource] = [
        "partycat": .imageUrl("https://github.com/GetStream/Streamoji/blob/main/meta/emojis/let_me_in.gif?raw=true"),
        "switaction": .imageAsset("bananadance"),
        "switactiongreen": .imageAsset("https://github.com/GetStream/Streamoji/blob/main/meta/emojis/let_me_in.gif?raw=true"),
        "party_parrot": .imageAsset("party_parrot.gif"),
        "this_is_fine": .imageAsset("this-is-fine-fire.gif"),
        "what": .imageAsset("what.png"),
        "homer_disappear": .imageAsset("homer-disappear.gif"),
        "let_me_in": .imageUrl("https://github.com/GetStream/Streamoji/blob/main/meta/emojis/let_me_in.gif?raw=true"),
        "smiley": .character("😄"),
        "heart": .character("❤️"),
        "banana": .alias("banana_dance"),
        "parrot": .alias("party_parrot")
    ]
    
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
        if name == ":swit:"{
            let myTextAttachment = MyTextAttachment()

            myTextAttachment.attachType = .lottie
            myTextAttachment.lottieName = name
            myTextAttachment.image = UIImage()
            myTextAttachment.bounds = CGRect(x: 0, y: 0, width: size, height: size)
            
            let emoji = NSMutableAttributedString()
            emoji.append(NSAttributedString(attachment: myTextAttachment))
            return emoji
        }
        name.removeFirst()
        name.removeLast()

        guard let inner = self.emojiDictionary[name] else {
      /*      let attachment = NSTextAttachment()
        
            attachment.image = UIImage(named: "swit")
            attachment.bounds = CGRect(x: 0, y: 0, width: size, height: size)

            let emoji = NSMutableAttributedString()
            emoji.append(NSAttributedString(attachment: attachment))
            return emoji
       */
            
            let myTextAttachment = MyTextAttachment()

            myTextAttachment.attachType = .lottie
            myTextAttachment.lottieName = name
            myTextAttachment.image = UIImage()
            myTextAttachment.bounds = CGRect(x: 0, y: 0, width: size, height: size)
            
            let emoji = NSMutableAttributedString()
            emoji.append(NSAttributedString(attachment: myTextAttachment))
            return emoji
        }
        return NSAttributedString(string: inner["name"] ?? "").fontSize(16)
    }
    
    
}
