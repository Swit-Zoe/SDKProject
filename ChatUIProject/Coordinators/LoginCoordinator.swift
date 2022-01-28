//
//  LoginCoordinator.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/26.
//

import Foundation
import UIKit

protocol LoginCoordinatorDelegate {
    func didLoggedIn(_ coordinator: LoginCoordinator)
}

class LoginCoordinator: Coodinator{
    var childCoorinators: [Coodinator] = []
    var delegate: LoginCoordinatorDelegate?
    
    private var navigationController:UINavigationController!
    
    init(navigationController:UINavigationController){
        self.navigationController = navigationController
    }
    
    func start(){
        let viewController = LoginViewController()
        viewController.delegate = self
        
        //self.navigationController.viewControllers = [viewController]
        self.navigationController.pushViewController(viewController, animated: true)
        
    }
    

}
extension LoginCoordinator:LoginViewControllerDelegate{
    func login() {
        self.delegate?.didLoggedIn(self)
    }
}
