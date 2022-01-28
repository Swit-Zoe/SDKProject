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
    
    public func setAnimationEmoji() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.setNeedsLayout()
            self.convertAnimationEmoji(){}
            self.layoutIfNeeded()
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
       
    func convertAnimationEmoji(complete:@escaping () -> ()){
        let length = self.attributedText.length
        self.attributedText.enumerateAttribute(.attachment, in: NSRange(location: 0, length: length), options: [], using: { value, range, stop in
                if value is MyTextAttachment {
                    let attachment = value as? MyTextAttachment
                    
                    self.selectedRange = range
                    var rect = CGRect()
                    if let selectedTextRange = self.selectedTextRange {
                        rect = self.firstRect(for: selectedTextRange)
                    }else{
                        return
                    }
                    if rect.origin.x == .infinity || rect.origin.y == .infinity{
                        print("inf")
                        complete()
                        return
                    }else{
                        print(rect.origin.x)
                        print(rect.origin.y)
                    }
                    
                    if attachment?.attachType == .lottie {
                        let av = AnimationView(name: "heart")
                        av.play()
                        av.loopMode = .loop
                        av.backgroundBehavior = .pauseAndRestore
                        av.contentMode = .scaleAspectFill
                        av.frame = rect
                        
                        self.addSubview(av)
                    }else if attachment?.attachType == .gif{
                        let iv = GIFImageView(frame: rect)
                        self.addSubview(iv)
                        iv.animate(withGIFNamed: "bananadance")
                    }
                }
        })
        self.selectedRange = NSRange(location: 0, length: 0)
    }
    
}
