//
//  ToolChainView.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/06.
//

import Foundation
import UIKit
import SnapKit

struct FontType{
    var font:UIFont = UIFont.systemFont(ofSize: 16)
    var italic:Float = 0.0
    var line:UIColor = .clear
    var backColor:UIColor = .clear
    var link:Bool = false
    var fontColor:UIColor = .labelColor
}

class ToolChainView:UIView{
    let normalView = UIView()
    let fontView = UIView()
    let addButton = UIButton()
    let alphaButton = UIButton()
    let textButton = UIButton()
    let rightArrowButton = UIButton()
    let boldButton = UIButton()
    let italicButton = UIButton()
    let lineButton = UIButton()
    let backColorButton = UIButton()
    let linkButton = UIButton()
    
    enum Size{
        static let imageSize:CGFloat = 28
        static let margin:CGFloat = 10
        static let marginLeft:CGFloat = 20
        static let fontSize:CGFloat = 16
    }
    
    var fontType:FontType = FontType()
    
    let selectedColor:[Bool:UIColor] = [true:.systemGray5,false:.clear]
    let selectedBold:[Bool:UIFont] = [true:UIFont.bold,
                                      false:UIFont.regular]
    
    override init(frame:CGRect){
        super.init(frame: frame)
        
        addSubview(normalView)
        addSubview(fontView)
        setButtonImage()

        normalView.flex
            .direction(.row)
            .alignItems(.center)
            .define { (flex) in
                
            flex.addItem(addButton)
                    .marginLeft(Size.marginLeft)
                    .marginRight(Size.margin)
                    .size(Size.imageSize)
                
            flex.addItem(alphaButton)
                    .marginHorizontal(Size.margin)
                    .size(Size.imageSize)
                
            flex.addItem(textButton)
                    .marginHorizontal(Size.margin)
                    .size(Size.imageSize)
        }
        
        fontView.flex.direction(.row)
            .alignItems(.center)
            .define { (flex) in
                
            flex.addItem(rightArrowButton)
                    .marginLeft(Size.marginLeft)
                    .marginRight(Size.margin)
                    .size(Size.imageSize)
                
            flex.addItem()
                    .marginHorizontal(Size.margin)
                    .backgroundColor(.systemGray3)
                    .height(Size.imageSize).width(1)
                
            flex.addItem(boldButton)
                    .marginHorizontal(Size.margin)
                    .size(Size.imageSize)
                
            flex.addItem(italicButton)
                    .marginHorizontal(Size.margin)
                    .size(Size.imageSize)
                
            flex.addItem(lineButton)
                    .marginHorizontal(Size.margin)
                    .size(Size.imageSize)
                
            flex.addItem(backColorButton)
                    .marginHorizontal(Size.margin)
                    .size(Size.imageSize)
                
            flex.addItem(linkButton)
                    .marginHorizontal(Size.margin)
                    .size(Size.imageSize)
        }
        
        setColor()
        setFontView(false)
        
        clipsToBounds = true
    }
    
    fileprivate func setButtonImage(){
        addButton.setImage(UIImage(named: "toolPlus"), for: .normal)
        alphaButton.setImage(UIImage(named: "toolAlpha"), for: .normal)
        textButton.setImage(UIImage(named: "toolText"), for: .normal)
        
        rightArrowButton.setImage(UIImage(named: "arrowRight"), for: .normal)
        boldButton.setImage(UIImage(named: "bold"), for: .normal)
        italicButton.setImage(UIImage(named: "Italic"), for: .normal)
        lineButton.setImage(UIImage(named: "line"), for: .normal)
        backColorButton.setImage(UIImage(named: "backcolor"), for: .normal)
        linkButton.setImage(UIImage(named: "link"), for: .normal)
        
        rightArrowButton.backgroundColor = .systemGray5
        rightArrowButton.makeRounded(radius: 14)
        
        if #available(iOS 15, *) {
            addButton.configuration?.imagePadding = 0
            addButton.configuration?.imagePlacement = .all
            
            alphaButton.configuration?.imagePadding = 0
            alphaButton.configuration?.imagePlacement = .all
            
            textButton.configuration?.imagePadding = 0
            textButton.configuration?.imagePlacement = .all
            
            rightArrowButton.configuration?.imagePadding = 2
            rightArrowButton.configuration?.imagePlacement = .all
        } else {
            addButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            alphaButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            textButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            rightArrowButton.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        }
    }
    
    public func setFontView(_ showFontView:Bool){
        fontView.isHidden = !showFontView
        normalView.isHidden = !fontView.isHidden
    }
    
    fileprivate func setColor(){
        backgroundColor = .backgroundColor
        addButton.tintColor = .toolChainTintColor
        alphaButton.tintColor = .toolChainTintColor
        textButton.tintColor = .toolChainTintColor
        
        rightArrowButton.tintColor = .toolChainTintColor
        boldButton.tintColor = .toolChainTintColor
        italicButton.tintColor = .toolChainTintColor
        lineButton.tintColor = .toolChainTintColor
        backColorButton.tintColor = .toolChainTintColor
        linkButton.tintColor = .toolChainTintColor
        
        rightArrowButton.backgroundColor = .rightArrowButtonColor
        
        [boldButton,italicButton,linkButton,lineButton,backColorButton].forEach {
            $0.layer.cornerRadius = 2
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        normalView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        fontView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        layout()
    }
    
    fileprivate func layout() {
        normalView.flex.layout(mode: .fitContainer)
        fontView.flex.layout(mode: .fitContainer)
    }
    
    
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
