// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation
import UIKit
import RichString
// MARK: - Welcome
struct BodyBlockSkit: Codable {
    let type: String
    let elements: [Elements]
}

// MARK: - WelcomeElement
struct Elements: Codable {
    let type: String
    let elements: [TextElements]
}

// MARK: - ElementElementClass
struct TextElements: Codable {
    let type: RichType
    let userID, content, name,url: String?
    let styles : Styles?

    enum CodingKeys: String, CodingKey {
        case type
        case userID = "user_id"
        case content, name, url, styles
    }
}
extension TextElements{
    func applyStyle(emojiDictionary:[String:[String:String]])->NSAttributedString{
        
        switch(self.type){
        case .text:
            guard let content = self.content else {return .empty}
            var mutable = content
                .font(UIFont.regular)
                .color(UIColor.labelColor)
            
            if let styles = self.styles{
                if let bold = styles.bold, bold{
                    mutable = mutable
                        .font(UIFont.bold)
                        .color(.labelColor)
                }
                if let code = styles.code, code{
                    mutable = mutable
                        .backgroundColor(.lightGray)
                        .color(.systemRed)
                }
                if let italic = styles.italic, italic{
                    mutable = mutable
                        .obliqueness(0.3)
                }
            }
            return mutable
            
        case .link:
            guard let content = self.content else {return .empty}
            var mutable = content.font(UIFont.regular).color(UIColor.labelColor)
            
            guard let url = self.url else {return mutable}
            guard let URL = NSURL(string: url) else {return mutable}
            mutable = mutable
                .color(UIColor.linkColor)
                .underline(color: UIColor.linkColor)
                .link(url: URL).fontSize(16)

            return mutable
            
        case .emoji:
            guard var name = self.name else {return .empty}
            name.removeFirst()
            name.removeLast()

            guard let inner = emojiDictionary[name] else {
                let attachment = NSTextAttachment()
            
                attachment.image = UIImage(named: "swit")
                attachment.bounds = CGRect(x: 0, y: 0, width: 28, height: 28)
    
                let emoji = NSMutableAttributedString()
                emoji.append(NSAttributedString(attachment: attachment))
                return emoji
            }
            return NSAttributedString(string: inner["name"] ?? "").fontSize(16)//contents.fontSize(16)
            
        case .mention:
            guard let userID = self.userID else {return .empty}
            return ("@" + userID)
                .color(UIColor.linkColor)
                .underline(color: UIColor.linkColor)
                .fontSize(16)
                .backgroundColor(.systemGray5)
            
        }
    }
}

enum RichType: String, Codable {
    case text = "rt_text"
    case mention = "rt_mention"
    case link = "rt_link"
    case emoji = "rt_emoji"
}


struct Styles: Codable {
    let bold: Bool?
    let code: Bool?
    let italic: Bool?
    let strike: Bool?
}
