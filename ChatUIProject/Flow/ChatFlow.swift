//
//  ChatFlow.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/27.
//

import Foundation
import RxFlow
import RxCocoa
import RxSwift

class ChatFlow: Flow {

    let stepper = ChatFlowStepper()

    var root: Presentable {
        return self.rootViewController
    }

    private let rootViewController: ChatListVC

    init(chatListVC:ChatListVC) {
        rootViewController = chatListVC
       // rootViewController = uiNavigationViewController
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? FlowStep else { return .none }
        switch step {
        case .toChatList:
            return self.navigateToChatList()
        case .toInChat(let channelID):
            return self.navigateToInChat(channelID:channelID)
        case .toInChatComment(let messageID):
            return self.navigateTotoInChatComment(messageID:messageID)
        case .toLogin:
            return .end(forwardToParentFlowWithStep: FlowStep.toLogin)
        default:
            return .none
        }
    }
    
    private func navigateToChatList() -> FlowContributors {
        print(#function)
        return .one(flowContributor: .contribute(withNext: rootViewController))
    }
    
    private func navigateToInChat(channelID:Int) -> FlowContributors {

        print(#function)
        let viewController = InChatVC()
        viewController.title = "News"


        
        self.rootViewController.navigationController?.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNext: viewController))
    }

    private func navigateTotoInChatComment(messageID:Int) -> FlowContributors {
        print(#function)
        let viewController = ChatCommentVC()
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .coverVertical
        self.rootViewController.present(viewController, animated: true, completion: nil)
        
        //self.rootViewController.navigationController?.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNext: viewController))
    }
}

class ChatFlowStepper:Stepper{
    var steps = PublishRelay<Step>()
}
