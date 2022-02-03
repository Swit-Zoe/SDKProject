//
//  NotiView.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/02/01.
//

import Foundation
import FlexLayout
import SnapKit
import UIKit
import Then

class NotiView:ContentsContainer{
    let notiViewLabel = UILabel().then{
        $0.textColor = .label
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.textAlignment = .center
        $0.backgroundColor = .systemGray5
    }
    
    override init(){
        super.init()
        
        sub = [notiViewLabel]
        
        self.flex.define { flex in
            flex.addItem(notiViewLabel)
                .backgroundColor(.systemGray5)
                .marginVertical(8)
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

