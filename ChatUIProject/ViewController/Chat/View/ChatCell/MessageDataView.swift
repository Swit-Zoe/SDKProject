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

class MessageDataView:ContentsContainer{
    
    let contentContainer = UIView()
    
    let profileImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
        $0.image = UIImage(named: "profile")
    }
    let textContentContainer = ContentsContainer()

    let nameLabel = UILabel().then {
        $0.font = .regular
        $0.textAlignment = .left
        $0.textColor = .labelColor
    }
    
    let chatLabel = UITextView().then {
        $0.font = .regular
        $0.backgroundColor = .clear
        $0.layer.borderColor = UIColor.systemGray5.cgColor
        $0.layer.cornerRadius = 3
        $0.linkTextAttributes = [.underlineColor:UIColor.linkColor,
                                 .underlineStyle:1,
                                 .foregroundColor:UIColor.linkColor]
        $0.isScrollEnabled = false
    }
    
    let timeLabel = UILabel().then{
        $0.numberOfLines = 1
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textAlignment = .left
        $0.textColor = .systemGray5
    }
    
    let hashtagLabel = UILabel().then{
        $0.numberOfLines = 1
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textAlignment = .left
        $0.textColor = .linkColor
    }
    
    override init(){
        super.init()
        
        sub = [contentContainer,
               textContentContainer]
        
        textContentContainer.sub =
        [chatLabel,
        timeLabel,
        hashtagLabel]
        
        self.layer.borderColor = UIColor.systemGray5.cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 5
        
        self.flex.addItem()
            .paddingHorizontal(16)
            .direction(.column)
            .paddingVertical(8)
            .define { flex in
                
                flex.addItem(contentContainer)
                    .direction(.row)
                    .right(0)
                    .marginTop(8)
                    .left(0)
                    .define { flex in
                        flex.addItem(profileImage).size(32)
                        
                        flex.addItem(nameLabel)
                            .alignSelf(.stretch)
                            .marginLeft(8)
                            .define { (flex) in}
                    }
                
                flex.addItem(textContentContainer)
                    .paddingLeft(16)
                    .marginTop(8)
                    .direction(.column)
                    .justifyContent(.spaceBetween)
                    .grow(1)
                    .shrink(1)
                    .define { (flex) in

                        flex.addItem(chatLabel)
                            .alignSelf(.stretch)
                        
                        flex.addItem(timeLabel)
                            .alignSelf(.stretch)
                            .define { (flex) in}
                        
                        flex.addItem(hashtagLabel)
                            .alignSelf(.stretch)
                            .define { (flex) in}
                        
                    }
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

