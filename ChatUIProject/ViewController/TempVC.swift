//
//  TempVC.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/27.
//

import Foundation
import UIKit
import Then
import RxFlow
import RxCocoa

class TempVC:UIViewController,Stepper{
    let steps = PublishRelay<Step>()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("tempVC")
        let label = UILabel().then {
            $0.text = "This is temp VC"
            $0.frame = CGRect(x: 0,
                              y: 0,
                              width: $0.intrinsicContentSize.width,
                              height: $0.intrinsicContentSize.height)
            $0.textColor = .label
        }
        
        view.addSubview(label)
        label.center = view.center
        
    }
}
