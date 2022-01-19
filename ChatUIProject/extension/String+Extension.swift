//
//  String+Extension.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/12.
//

import Foundation

extension String {
    static var space = " ".fontSize(16)
    static var empty = "".fontSize(16)
    var isSingleEmoji: Bool { count == 1 && containsEmoji }
    var containsEmoji: Bool { contains { $0.isEmoji } }
    var containsOnlyEmoji: Bool { !isEmpty && !contains { !$0.isEmoji } }
    var emojiString: String { emojis.map { String($0) }.reduce("", +) }
    var emojis: [Character] { filter { $0.isEmoji } }
    var emojiScalars: [UnicodeScalar] { filter { $0.isEmoji }.flatMap { $0.unicodeScalars } }
}
