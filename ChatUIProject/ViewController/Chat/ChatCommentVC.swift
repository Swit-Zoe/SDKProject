//
//  ChatCommentVC.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/26.
//

import Foundation
import UIKit
import Then
import FlexLayout
import PinLayout
import SnapKit
import RxFlow
import RxSwift
import RxCocoa

class ChatCommentVC:UIViewController,Stepper{
    var steps: PublishRelay<Step> = PublishRelay<Step>()
    
    let titleBar = UIView().then {
        $0.backgroundColor = .backgroundColor
    }
    let tempLabel = UILabel().then{
        $0.text = "This is a comment area"
        $0.text = "this is comment area"
        $0.textColor = .label
        $0.textAlignment = .center
    }
    let backButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        $0.tintColor = .label
    }
    let bottomBorder = UIView().then{
        $0.backgroundColor = .lightGray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        
        view.addSubview(titleBar)
        titleBar.addSubview(tempLabel)
        titleBar.addSubview(backButton)
        titleBar.addSubview(bottomBorder)
        
        titleBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(48)
        }
        
        tempLabel.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.width.equalTo(tempLabel.intrinsicContentSize.width)
            $0.height.equalTo(tempLabel.intrinsicContentSize.height)
        }
        
        bottomBorder.snp.makeConstraints{
            $0.width.equalToSuperview()
            $0.height.equalTo(0.3)
            $0.left.right.bottom.equalToSuperview()
        }
        
        backButton.snp.makeConstraints{
            $0.width.equalTo(48)
            $0.height.equalTo(48)
            $0.left.top.bottom.equalToSuperview()
        }
        
        
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
       
    }

    @objc func back(){
        dismiss(animated: true, completion: nil)
    }
    
}
