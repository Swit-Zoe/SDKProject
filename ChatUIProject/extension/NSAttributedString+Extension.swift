//
//  NSAttributedString+Extension.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/11.
//

import Foundation

extension NSAttributedString {
    var attributedStringToRtf: String? {
        do {
            let rtfData = try self.data(from: NSRange(location: 0, length: self.length), documentAttributes:[.documentType: NSAttributedString.DocumentType.rtf]);
            return String.init(data: rtfData, encoding: String.Encoding.utf8)
        } catch {
            print("error:", error)
            return nil
        }
    }
    static var empty = NSAttributedString(string:"").fontSize(16)
    
}
