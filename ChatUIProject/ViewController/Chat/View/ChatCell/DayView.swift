//
//  DayView.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/02/01.
//

import Foundation
import FlexLayout
import SnapKit
import UIKit
import Then

class DayView:ContentsContainer{
    let dayChangeLabel = UILabel().then {
        $0.textColor = .lightGray
        $0.numberOfLines = 1
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    let dummy1 = UIView()
    let dummy2 = UIView()
    
    override init(){
        super.init()
        
        sub = [dayChangeLabel,dummy1,dummy2]
        
        self.flex.define { flex in
            flex.addItem(dummy1)
                .direction(.row)
                .height(1)
                .width(300)
                .backgroundColor(.systemGray5)
                .alignSelf(.center)
                .define{ flex in}
            
            flex.addItem(dayChangeLabel)
                .direction(.row)
                .backgroundColor(.clear)
                .alignSelf(.center)
                .define{ flex in}
            
            flex.addItem(dummy2)
                .direction(.row)
                .height(1)
                .width(300)
                .backgroundColor(.systemGray5)
                .alignSelf(.center)
                .define{ flex in}
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

