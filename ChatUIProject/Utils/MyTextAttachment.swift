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
}

class MyTextAttachment:NSTextAttachment{
    var attachType:AttachType?
    var lottieName:String?
}
