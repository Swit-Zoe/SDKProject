//
//  TextFieldExtension.swift
//  ChatUIProject
//
//  Created by park kevin on 2021/12/27.
//

import Foundation
import UIKit
import LinkPresentation
import Gifu
import Lottie


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
    
    open override func layoutSubviews() {
        //self.ReplaceAttachmentGif()
     //   convertGif()
     //   super.layoutSubviews()
        print(#function)
    }
    
    public func setLottieEmoji() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.convertGif()
        }
        //self.convertGif()

//        NotificationCenter.default.addObserver(
//            forName: UITextView.textDidChangeNotification,
//            object: self,
//            queue: .main
//        ) { [weak self] _ in
//            self?.convertGif()
//        }
    }
       
    func convertGif(){
        let length = self.attributedText.length
        self.attributedText.enumerateAttribute(.attachment, in: NSRange(location: 0, length: length), options: [], using: { value, range, stop in

                if value is MyTextAttachment {
                    
                    let attachment = value as? MyTextAttachment

                    if attachment?.attachType == .lottie {

                        self.selectedRange = range

                        guard
                        let position1 = self.position(from: self.beginningOfDocument, offset: range.location),
                        let position2 = self.position(from: position1, offset: range.length),
                        let cRange = self.textRange(from: position1, to: position2)
                        else {return}
                            
                        var rect = self.firstRect(for: cRange)
               //         var selectionRect:[UITextSelectionRect]
    //                    if let selectedTextRange = self.selectedTextRange {
    //                        selectionRect = self.selectionRects(for: selectedTextRange)//self.firstRect(for: selectedTextRange)
    //                    }else{
    //                        return
    //                    }
                       // selectionRect.forEach{rect = rect.union($0.rect);}
//                        if let selectedTextRange = self.selectedTextRange {
//                           rect = self.firstRect(for: selectedTextRange)
//                       }else{
//                           return
//                       }
                    //    rect.origin.x = 5
                     //   rect.origin.y = 7
                        print( "\(rect.origin.x) + \(rect.origin.y)")
                        //rect.size = CGSize(width: 20, height: 20)
                        
                        let av = AnimationView(name: "heart")
                        av.play()
                        av.loopMode = .loop
                        av.frame = rect

                        self.addSubview(av)
                       // attachment?.image = UIImage.imageWithColor(color: .clear)

                    }
                }
            
            

        })
        self.selectedRange = NSRange(location: 0, length: 0)
    }
    
}
