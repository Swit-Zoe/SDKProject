//
//  MessageInputBar.swift
//  ChatUIProject
//
//  Created by park kevin on 2021/12/27.
//

import UIKit

import RxCocoa
import RxSwift
import RxKeyboard

final class MessageInputBar:UIView,UITextViewDelegate{
    private let disposeBag = DisposeBag()
    var previousLength = 0
    var backLatch = false
    var fontClick = 0
    var spaceRange:NSRange?
    enum Size{
        static let minHeight:CGFloat = 48.0
        static let maxHeight:CGFloat = 144.0
        static let maxLength = 100
    }
    
    let textView:UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = true
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.showsVerticalScrollIndicator = false
        
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.backgroundColor = .white
        
        textView.addPadding(leading:16,trailing:70,top:16,bottom:16)
        textView.dataDetectorTypes = .all
        return textView
    }()
    
    let placeHolerLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Enter messege"
        label.textColor = UIColor(rgb: 0xB9BABE)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        return label
    }()
    
    let sendButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "airPlane"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        if #available(iOS 15, *) {
            button.configuration?.imagePadding = 8
            button.configuration?.imagePlacement = .all
        } else {
            button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        }
        button.clipsToBounds = true
        button.layer.cornerRadius = 4
        //  button.backgroundColor = .systemGray5
        button.setBackgroundColor(color: UIColor.sendButtonDisabledColor, forState: .disabled)
        button.setBackgroundColor(color:  UIColor.sendButtonNormalColor, forState: .normal)
        
        button.tintColor = .white
        
        button.adjustsImageWhenHighlighted = false
        button.adjustsImageWhenDisabled = false
        button.isEnabled = false
        // button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.textView)
        self.addSubview(self.sendButton)
        self.addSubview(self.placeHolerLabel)
        
        self.textView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.placeHolerLabel.snp.makeConstraints {
            $0.edges.equalTo(textView).inset(UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 0))
        }
        self.sendButton.snp.makeConstraints {
            $0.centerY.equalTo(textView.snp.centerY)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(42)
            $0.height.equalTo(32)
        }
        
        setColor()
    }
    
    fileprivate func setColor(){
        textView.textColor = UIColor.labelColor
        textView.backgroundColor = UIColor.backgroundColor
        textView.layer.borderColor = UIColor.systemGray3.cgColor
    }
    
    
    
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Size
    
//    override var intrinsicContentSize: CGSize {
//        return CGSize(width: self.width, height: 44)
//    }
//
}
