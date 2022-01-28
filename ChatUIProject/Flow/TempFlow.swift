//
//  HomeFlow.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/26.
//

import Foundation
import RxFlow

class TempFlow: Flow {

    var root: Presentable {
        return self.rootViewController
    }

    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        return viewController
    }()

    init() {}

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? FlowStep else { return .none }
        switch step {
        case .toTemp:
            return self.navigateToTemp()
        case .toLogin:
            return .end(forwardToParentFlowWithStep: FlowStep.toLogin)
        default:
            return .none
        }
    }
    
    private func navigateToTemp() -> FlowContributors {
        print(#function)
        let viewController = TempVC()
        self.rootViewController.setViewControllers([viewController], animated: false)
        return .one(flowContributor: .contribute(withNext: viewController))
    
    }
}
