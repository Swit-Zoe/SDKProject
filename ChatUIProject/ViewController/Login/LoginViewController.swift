//
//  LoginViewController.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/26.
//

import Foundation
import UIKit
import RxFlow
import RxSwift
import RxCocoa

protocol LoginViewControllerDelegate{
    func login()
}

class LoginViewController:UIViewController,Stepper{
    var steps: PublishRelay<Step> = PublishRelay<Step>()
    var delegate:LoginViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = UIButton()
        loginButton.setTitle("Login", for: .normal)
        loginButton.setBackgroundColor(color: .systemBlue, forState: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
        
        view.addSubview(loginButton)
        
        loginButton.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        loginButton.center = view.center
        
    }
    
    @objc func loginButtonDidTap(){
        //self.delegate?.login()
        self.steps.accept(FlowStep.toDashboard)
    }
}
