// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation
import UIKit
import RichString

struct BodyBlocksKit : Codable{
    var type : String?
    var elements : [Elements]?
}

struct Elements : Codable{
    var type : String?
    var elements : [TextElements]?
}

struct TextElements : Codable{
    var type : RichType?
    var content : String?
    var styles : Styles?
    var url : String?
    var indent : Int?
    var elements : [TextElements]?
    var userID : String?
    var name : String?
    
    enum CodingKeys: String, CodingKey {
        case type
        case userID = "user_id"
        case content, name, url, styles
        case indent
    }
}

struct Styles : Codable {
    var bold : Bool?
    var italic : Bool?
    var strike : Bool?
    var code : Bool?
}

enum RichType: String, Codable {
    case text = "rt_text"
    case mention = "rt_mention"
    case link = "rt_link"
    case emoji = "rt_emoji"
}

extension TextElements{
    func applyStyle()->NSAttributedString{
        switch(self.type){
        case .text:
            guard let content = self.content else {
                return .empty
            }
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
            guard let name = self.name else {return .empty}

            return EmojiUtils.shared.getEmoji(name: name,size:22)
            
        case .mention:
            guard let userID = self.userID else {return .empty}
            return ("@" + userID)
                .color(UIColor.linkColor)
                .underline(color: UIColor.linkColor)
                .fontSize(16)
                .backgroundColor(.systemGray5)
            
        case .none:
            return .empty
        }
    }
}
