//
//  OGView.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/30.
//

import Foundation
import FlexLayout
import SnapKit
import UIKit
import Then
class OGView:ContentsContainer{
    let youtubeLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.textColor = .systemGray5
    }
    let titleLabel = UILabel().then {
        $0.numberOfLines = 0
    }
    let descriptionLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.textColor = .systemGray5
    }
    let urlLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 11)
        $0.textColor = .systemGray5
    }
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    var imageURL:URL?
    
    override init(){
        
        super.init()
        
        self.layer.borderColor = UIColor.systemGray5.cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 5
        
        sub = [youtubeLabel,
               titleLabel,
               descriptionLabel,
               urlLabel,
               imageView]
        
        self.flex.width(100%)
            .direction(.column)
            .padding(16)
            .define { flex in
                flex.addItem(youtubeLabel)
                    .width(100%)
                flex.addItem(titleLabel)
                    .width(100%)
                    .marginTop(16)
                flex.addItem(descriptionLabel).width(100%)
                    .marginTop(4)
                flex.marginTop(4)
                    .addItem(urlLabel)
                    .width(100%)
                    .marginTop(4)
                flex.addItem(imageView)
                    .width(100%)
                    .marginTop(4)
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
