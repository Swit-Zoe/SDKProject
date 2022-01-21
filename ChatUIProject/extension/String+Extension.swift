//
//  String+Extension.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/12.
//

import Foundation
import UIKit
import RichString

extension String {
    static var space = " ".fontSize(16)
    static var empty = "".fontSize(16)
    var isSingleEmoji: Bool { count == 1 && containsEmoji }
    var containsEmoji: Bool { contains { $0.isEmoji } }
    var containsOnlyEmoji: Bool { !isEmpty && !contains { !$0.isEmoji } }
    var emojiString: String { emojis.map { String($0) }.reduce("", +) }
    var emojis: [Character] { filter { $0.isEmoji } }
    var emojiScalars: [UnicodeScalar] { filter { $0.isEmoji }.flatMap { $0.unicodeScalars } }
    var decodingUnicodeCharacters: String { applyingTransform(.init("Hex-Any"), reverse: false) ?? "" }
    //MARK: decode body block skit to attribute text array
    func convertRichText()->NSAttributedString{
        let data = Data(self.utf8)
        let decoder = JSONDecoder()
        
        guard let result = try? decoder.decode(BodyBlockSkit.self, from: data) else {return "".fontSize(16)}
        guard let element = result.elements.first else {return "".fontSize(16)}
        
        var nsAttributeString = NSAttributedString(string: "")
        
        element.elements.forEach{
            var attributeString = NSAttributedString(string: "")
            switch($0.type){
            case .text:
                guard let contents = $0.content else {return}
                print(contents)
                attributeString = contents.font(UIFont.regular).color(.labelColor)
                if let styles = $0.styles{
                    print("asdfasdfasdf")
                    
                    if let bold = styles.bold, bold{
                        attributeString = contents.font(UIFont.bold).color(.labelColor)
                    }
                    if let code = styles.code, code{
                        attributeString = attributeString.backgroundColor(.lightGray).color(.systemRed)
                    }
                    if let italic = styles.italic, italic{
                        attributeString = attributeString.obliqueness(0.3)
                    }
                }
                break
            case .link:
                guard let contents = $0.content else {return}
                guard let url = $0.url else {return}
                guard let URL = NSURL(string: url) else {return}
                attributeString = contents.color(UIColor.linkColor).underline(color: UIColor.linkColor).link(url: URL).fontSize(16)
                break
            case .emoji:
                guard let contents = $0.name else {return}
                attributeString = NSAttributedString(string: "\u{3297}").fontSize(16)//contents.fontSize(16)
                //"\u{3297}".unicodeScalars
//                func convertToDictionary(text: String) -> [String: Any]? {
//                    if let data = text.data(using: .utf8) {
//                        do {
//                            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//                        } catch {
//                            print(error.localizedDescription)
//                        }
//                    }
//                    return nil
//                }
                break
            case .mention:
                guard var contents = $0.userID else {return}
                contents = "@" + contents
                attributeString = contents.color(UIColor.linkColor).underline(color: UIColor.linkColor).fontSize(16)
                break
            }
            nsAttributeString = nsAttributeString + attributeString
        }
        print("bodyBlockskit")
        print(result)
        
        return nsAttributeString
    }
}
