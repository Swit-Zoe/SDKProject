//
//  ColorExtension.swift
//  testForNewMac
//
//  Created by Kevin on 2021/12/22.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    public convenience init(hex: String) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 1
        
        let hexColor = hex.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0
        var valid = false
        
        if scanner.scanHexInt64(&hexNumber) {
            if hexColor.count == 8 {
                r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                a = CGFloat(hexNumber & 0x000000ff) / 255
                valid = true
            }
            else if hexColor.count == 6 {
                r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                b = CGFloat(hexNumber & 0x0000ff) / 255
                valid = true
            }
        }
        
#if DEBUG
        assert(valid, "UIColor initialized with invalid hex string")
#endif
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    static var linkColor:UIColor = UIColor(rgb: 0x3b99f7)
    static var chatLabelColor: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .light {
                return UIColor(rgb: 0x343434)
            } else {
                return UIColor(rgb: 0xEDEFF2)
            }
        }
    }
    static var chatTimeColor: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .light {
                return UIColor(rgb: 0xB9BABE)
            } else {
                return UIColor(rgb: 0x8B8E95)
            }
        }
    }
    static var chatBackgroundColor: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .light {
                return UIColor(rgb: 0xF8F8F8)
            } else {
                return UIColor(rgb: 0x000000)
            }
        }
    }
    static var toolChainTintColor: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .light {
                return UIColor(rgb: 0x343434)
            } else {
                return UIColor(rgb: 0xEDEFF2)
            }
        }
    }
    static var backgroundColor: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .light {
                return .white
            } else {
                return .black
            }
        }
    }
    static var backgroundColorReverse: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .light {
                return .black
            } else {
                return .white
            }
        }
    }
    static var labelColor: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .light {
                return .black
            } else {
                return .white
            }
        }
    }
    static var textViewBackgroundColor: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .light {
                return UIColor(rgb: 0xFFFFFF)
            } else {
                return UIColor(rgb: 0x161618)
            }
        }
    }
    
    static var rightArrowButtonColor: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .light {
                return .systemGray5
            } else {
                return .systemGray3
            }
        }
    }
    
    static var sendButtonNormalColor = UIColor(rgb: 0x478BFF)
    static var sendButtonDisabledColor = UIColor.systemGray2//UIColor(rgb: 0xB9BABE)
    
}
