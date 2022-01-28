//
//  HomeFlow.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/26.
//

import Foundation
import RxFlow

class HomeFlow: Flow {

    var root: Presentable {
        return self.rootViewController
    }

//    private lazy var rootViewController: UINavigationController = {
//        let viewController = UINavigationController()
//        return viewController
//    }()

    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        return viewController
    }()
    
    init() {}

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? FlowStep else { return .none }
        switch step {
        case .toHome:
            return self.navigateToHome()
        case .toLogin:
            return .end(forwardToParentFlowWithStep: FlowStep.toLogin)
        default:
            return .none
        }
    }
    
    private func navigateToHome() -> FlowContributors {
        print(#function)
        let viewController = PageVC(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [:])
        
        self.rootViewController.pushViewController(viewController, animated: true)
        
        let chatFlow = ChatFlow(chatListVC:ChatListVC())//(uiNavigationViewController: rootViewController)
        let taskFlow = TaskFlow(projectListVC:ProjectListVC())//(uiNavigationViewController: rootViewController)

        Flows.use(chatFlow, taskFlow, when: .created) { chatRoot, taskRoot in
            viewController.pages = [chatRoot, taskRoot]
            print("very good")
        }
        
        return .multiple(flowContributors: [.contribute(withNextPresentable: chatFlow,
                                                        withNextStepper: OneStepper(withSingleStep: FlowStep.toChatList)/*chatFlow.stepper*/,
                                                        allowStepWhenDismissed: true),
                                            .contribute(withNextPresentable: taskFlow,
                                                        withNextStepper: OneStepper(withSingleStep: FlowStep.toProjectList)/*taskFlow.stepper*/,
                                                        allowStepWhenDismissed: true)])
    }
}
