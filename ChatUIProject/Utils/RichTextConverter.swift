//
//  RichTextConverter.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/02/03.
//

import Foundation
import RichString

class RichTextConverter{
    static let shared = RichTextConverter()
    
    func convertRichText(chat:Chat? = nil,bodyBlockskit:String? = nil)->NSAttributedString{
        var string = ""
        var dummy:NSAttributedString = .empty
        if bodyBlockskit != nil{
            string = bodyBlockskit!
        }else{
            string = chat!.bodyBlockskit
            dummy = chat!.bodyText.fontSize(16).color(.label)
        }
        
        let data = Data(string.utf8)
        let decoder = JSONDecoder()
        if data.count == 0 {
            return dummy
        }
        guard let result = try? decoder.decode(BodyBlocksKit.self, from: data) else {
            return dummy
        }
        
        guard let elements = result.elements else {return dummy}
        
        var viewString = NSAttributedString(string: "")
        elements.forEach{ element in
            element.elements!.forEach{
                viewString = viewString + $0.applyStyle()
            }
            viewString = viewString + NSAttributedString(string: "\n")
            
        }

        return viewString
    }
}
