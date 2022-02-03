//
//  UIImageView+Extension.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/30.
//

import Foundation
import UIKit
extension UIImageView{
    func scaledSize() -> CGSize{
        if let myImage = self.image {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width

            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio
            let scaledWidth = myImageWidth * ratio

           // self.frame.size.height = scaledHeight
            return CGSize(width: scaledWidth, height: scaledHeight)
            
        }
        return CGSize(width: 0, height: 0)
    }
   
}
