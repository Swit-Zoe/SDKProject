//
//  LoginFlow.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/26.
//

import Foundation
import RxFlow

class LoginFlow: Flow {

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
        case .toLogin:
            return self.navigateToLogin()
        case .toDashboard:
            return .end(forwardToParentFlowWithStep: FlowStep.toDashboard)
        default:
            return .none
        }
    }
    
    private func navigateToLogin() -> FlowContributors {
        let viewController = LoginViewController()
        self.rootViewController.setViewControllers([viewController], animated: false)
        return .one(flowContributor: .contribute(withNext: viewController))
    }
}
