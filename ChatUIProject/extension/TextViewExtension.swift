//
//  TextFieldExtension.swift
//  ChatUIProject
//
//  Created by park kevin on 2021/12/27.
//

import Foundation
import UIKit
import LinkPresentation


extension UITextView{
    func addPadding(leading:CGFloat,trailing:CGFloat,top:CGFloat,bottom:CGFloat){
        self.textContainerInset = UIEdgeInsets(top: top, left: leading, bottom: bottom, right: trailing)
    }
    
    func detectLink(completion: @escaping (LPLinkView)->Void){
 
        if let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue){
            
            let matchs = detector.matches(in: self.text, options: [], range: NSRange(location: 0, length: self.text.count))
            
            let provider = LPMetadataProvider()
            
            matchs.forEach{
                guard let range = Range($0.range,in: self.text)else{return}
                let urlString = self.text[range]
                print(urlString)
                
                guard let url = URL(string: String(urlString)) else {return}
                
                provider.startFetchingMetadata(for: url) { metaData, error in
                    guard let data = metaData, error == nil else{return}
                    DispatchQueue.main.async {
                        let linkPreview = LPLinkView()
                        linkPreview.metadata = data
                        linkPreview.frame = CGRect(x: 0, y: 0, width: 250, height: linkPreview.intrinsicContentSize.height)
       
                        completion(linkPreview)
                    }
                }
            }
        }
    
    }
}
