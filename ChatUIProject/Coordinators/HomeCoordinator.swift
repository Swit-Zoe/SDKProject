//
//  HomeCoordinator.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/26.
//

import Foundation
import UIKit

protocol HomeCoordinatorDelegate{
    func didLoggedOut(_ coordinator: HomeCoordinator)
}

class HomeCoordinator:Coodinator{
    var childCoorinators: [Coodinator] = []
    var delegate:HomeCoordinatorDelegate?
    
    private var navigationController:UINavigationController!
   
    init(navigationController:UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(){
        let viewController = PageVC()
      //  viewController.coordinatorDelegate = self
        self.navigationController.pushViewController(viewController, animated: true)
    }
        
}

extension HomeCoordinator:PageVCDelegate{
    func goToChannel() {
        self.navigationController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
        
        let coordinator = InChatCoordinator(navigationController: self.navigationController)
        coordinator.delegate = self
        coordinator.start()

        self.childCoorinators.append(coordinator)
    }
    
    func goToTask() {
        let nextVC = KanbanViewController()
        nextVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func logout() {
        self.delegate?.didLoggedOut(self)
    }
}

extension HomeCoordinator:InChatCoordinatorDelegate{
    func backTapped(_ coordinator: InChatCoordinator) {
        self.childCoorinators = self.childCoorinators.filter{$0 !== coordinator}
    }
}
