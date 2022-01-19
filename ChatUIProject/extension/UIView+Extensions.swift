//
//  UIView+Extensions.swift
//  ChatUIProject
//
//  Created by Zoe on 2022/01/06.
//

import Foundation
import UIKit

extension UIView {
    func makeRounded(radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
    }

    func makeRoundedWithBorder(radius: CGFloat, color: CGColor, borderWith: CGFloat = 1) {
        makeRounded(radius: radius)
        self.layer.borderWidth = borderWith
        self.layer.borderColor = color
    }
}
