//
//  ChatContentsView.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/02/01.
//

import Foundation
import FlexLayout
import SnapKit
import UIKit
import Then

class ImageAssetContainer:ContentsContainer{
    
    let contentContainer = ContentsContainer()
    let contentContainer2 = ContentsContainer()

    override init(){
        super.init()
        
        sub = [contentContainer]
        
        self.flex
            .define { flex in
                
                flex.addItem(contentContainer)
                    .direction(.row)
                    .right(0)
                    .justifyContent(.center)
                    .left(0)
                    .define { flex in}
                
            }
    }
  
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.flex.layout(mode: .adjustHeight)
    }
}

