//
//  AppCoordinator.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/26.
//

import Foundation
import UIKit

protocol Coodinator : AnyObject{
    var childCoorinators : [Coodinator] {get set}
    func start()
}

class AppCoordinator:Coodinator{
    
    var childCoorinators: [Coodinator] = []
    private var navigationController:UINavigationController!
    
    var isLoggedIn = true
    
    init(navigationController:UINavigationController){
        self.navigationController = navigationController
    }

    func start() {
        if isLoggedIn{
            self.showHome()
        }else{
            self.showLogin()
        }
        
    }
    
    private func showHome(){
        let coordinator = HomeCoordinator(navigationController: self.navigationController)
        coordinator.delegate = self
        coordinator.start()
        self.childCoorinators.append(coordinator)
    }
    private func showLogin(){
        let coordinator = LoginCoordinator(navigationController: self.navigationController)
        coordinator.delegate = self
        coordinator.start()
        self.childCoorinators.append(coordinator)
    }
}

extension AppCoordinator:LoginCoordinatorDelegate{
    func didLoggedIn(_ coordinator: LoginCoordinator) {
        self.childCoorinators = self.childCoorinators.filter{$0 !== coordinator}
        self.showHome()
    }
}

extension AppCoordinator:HomeCoordinatorDelegate{
   
    func didLoggedOut(_ coordinator: HomeCoordinator) {
        self.childCoorinators = self.childCoorinators.filter{$0 !== coordinator}
        self.showLogin()
    }
}


