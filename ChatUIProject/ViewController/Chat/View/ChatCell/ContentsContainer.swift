//
//  ProtocolView.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/02/02.
//

import Foundation
import UIKit
import FlexLayout

protocol Subviews{
    var sub : [UIView] { get set }
    func hide()
    func show()
    func dirty()
    func refresh()
}

class ContentsContainer:UIView,Subviews{
    func refresh() {
        sub.forEach{
            if $0 is ContentsContainer{
                let v = $0 as! ContentsContainer
                v.refresh()
            }
            $0.flex.layout()
        }
        self.flex.layout()
    }
    
    func dirty() {
        sub.forEach{
            if $0 is ContentsContainer{
                let v = $0 as! ContentsContainer
                v.dirty()
            }
            $0.flex.markDirty()
        }
        self.flex.markDirty()
    }
    
    func hide() {
        sub.forEach{
            if $0 is ContentsContainer{
                let v = $0 as! ContentsContainer
                v.hide()
            }
            $0.flex.display(.none)
        }
        self.flex.display(.none)
    }
    
    func show() {
        sub.reversed().forEach{
            if $0 is ContentsContainer{
                let v = $0 as! ContentsContainer
                v.show()
            }
            $0.flex.display(.flex)
        }
        self.flex.display(.flex)
    }
    
    var sub: [UIView] = []
    
    init(){
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.flex.layout(mode: .adjustHeight)
    }
}
