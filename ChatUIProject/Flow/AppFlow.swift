//
//  LoginFlow.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/26.
//


import Foundation
import UIKit.UINavigationController
import RxFlow
import RxSwift
import RxCocoa

class AppFlow: Flow {
    
    var window:UIWindow
    
    var root: Presentable {
        return self.window
    }

    init(window:UIWindow){
        self.window = window
    }

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? FlowStep else { return .none }

        switch step {
        case .toLogin:
            return navigateToLogin()
        case .toDashboard:
            return navigateToDashBoard()
        default:
            return .none
        }
    }

    private func navigateToLogin() -> FlowContributors {
        let loginFlow = LoginFlow()
        Flows.use(loginFlow, when: .created) { (root) in
            self.window.rootViewController = root
        }
        return .one(flowContributor: .contribute(withNextPresentable: loginFlow,
                                                 withNextStepper: OneStepper(withSingleStep: FlowStep.toLogin)))
    }

    private func navigateToDashBoard() -> FlowContributors {
        let dashBoardFlow = DashBoardFlow()
        Flows.use(dashBoardFlow, when: .created) { (root) in
            self.window.rootViewController = root
        }
        return .one(flowContributor: .contribute(withNextPresentable: dashBoardFlow,
                                                 withNextStepper: OneStepper(withSingleStep: FlowStep.toDashboard)))
    }

}

class AppStepper: Stepper {

    let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()

    init() {}

    var initialStep: Step{
        return FlowStep.toLogin
    }
}
