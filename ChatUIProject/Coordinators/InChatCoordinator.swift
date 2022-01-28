//
//  InChatCoordinator.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/26.
//

import Foundation
import UIKit

protocol InChatCoordinatorDelegate {
    func backTapped(_ coordinator: InChatCoordinator)
}

class InChatCoordinator:Coodinator{
    var delegate:InChatCoordinatorDelegate?
    var inChatVC:InChatVC?
    
    var childCoorinators: [Coodinator] = []
    
    private var navigationController:UINavigationController?
    
    init(navigationController:UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let inChatVC = InChatVC()
        inChatVC.modalPresentationStyle = .fullScreen
        inChatVC.inChatVCDelegate = self
        self.inChatVC = inChatVC
        self.navigationController?.pushViewController(inChatVC, animated: true)
    }
    

}

extension InChatCoordinator:InChatVCDelegate{
    func backTapped(){
        delegate?.backTapped(self)
    }
    func messageTapped() {
        let chatCommentVC = ChatCommentVC()
        chatCommentVC.view.backgroundColor = .backgroundColor
      //  chatCommentVC.modalTransitionStyle = .crossDissolve
      //  chatCommentVC.modalPresentationStyle = .fullScreen
        
      //  inChatVC?.present(chatCommentVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(chatCommentVC, animated: true)
    }
}

