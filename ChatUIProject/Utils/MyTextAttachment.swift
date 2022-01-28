//
//  MyTextAttachment.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/28.
//

import Foundation
import UIKit
import Lottie

enum AttachType{
    case image
    case lottie
    case gif
}

class MyTextAttachment:NSTextAttachment{
    var attachType:AttachType?
    var lottieName:String?
}
