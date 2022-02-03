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

class ChatContentsView:ContentsContainer{

    let contentContainer = ContentsContainer()
    
    let profileImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 24
        $0.clipsToBounds = true
        $0.image = UIImage(named: "profile")
    }
    let textContentContainer = ContentsContainer()
    let timaAndNameContainer = ContentsContainer()
    let nameLabel = UILabel().then {
        $0.font = .regular
        $0.textColor = UIColor.chatLabelColor
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
        $0.textColor = UIColor.chatLabelColor
    }
    var imageAssetContainer = ImageAssetContainer()
    var ogDataContainer = ContentsContainer()

    var messageDataView = MessageDataView().then{
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.systemGray5.cgColor
        $0.layer.cornerRadius = 3
    }
    
    let timeLabel = UILabel().then{
        $0.numberOfLines = 1
        $0.textAlignment = .right
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textColor = UIColor.chatTimeColor
    }
    let commentContainer = UIView()
    let reactionContainer = UIView()
    
    override init(){
        super.init()
        
        sub = [contentContainer]
        
        contentContainer.sub =
        [textContentContainer,
         profileImage]
        
        textContentContainer.sub =
        [timaAndNameContainer,
        chatLabel,
        ogDataContainer,
        messageDataView,
        commentContainer,
        reactionContainer]
        
        timaAndNameContainer.sub =
        [nameLabel,
        timeLabel]
    
        self.flex
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
                        flex.addItem(profileImage).size(48)
                        
                        flex.addItem(textContentContainer)
                            .paddingLeft(16)
                            .direction(.column)
                            .justifyContent(.spaceBetween)
                            .grow(1)
                            .shrink(1)
                            .define { (flex) in
                                
                                flex.addItem(timaAndNameContainer)
                                    .direction(.row)
                                    .justifyContent(.spaceBetween)
                                    .alignSelf(.stretch)
                                    .define { (flex) in
                                        
                                        flex.addItem(nameLabel).shrink(3)
                                        flex.addItem(timeLabel).shrink(1)
                                    }
                                flex.addItem(chatLabel)
                                    .alignSelf(.stretch)
                                
                                flex.addItem(imageAssetContainer)
                                    .define { flex in}
                                
                                flex.addItem(ogDataContainer)
                                    .define { flex in}
                                
                                flex.addItem(messageDataView)
                                    .define { flex in}
                                
                                flex.addItem(commentContainer)
                                    .direction(.row)
                                    .marginTop(16)
                                    .marginRight(16)
                                    .height(20)
                                    .backgroundColor(.clear)
                                    .define { flex in}
                                
                                flex.addItem(reactionContainer)
                                    .direction(.row)
                                    .wrap(.wrap)
                                    .marginTop(16)
                                    .marginRight(16)
                                    .backgroundColor(.clear)
                                    .define { flex in}
                            }
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

