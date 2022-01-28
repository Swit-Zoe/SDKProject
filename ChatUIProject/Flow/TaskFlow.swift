//
//  TaskFlow.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/27.
//
import Foundation
import RxFlow
import RxCocoa
import RxSwift

class TaskFlow: Flow {
    let stepper = TaskFlowStepper()
    
    var root: Presentable {
        return self.rootViewController
    }

    private var rootViewController: ProjectListVC = ProjectListVC()

    init(projectListVC:ProjectListVC) {
        rootViewController = projectListVC
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? FlowStep else { return .none }
        switch step {
        case .toProjectList:
            return self.navigateToProjectList()
        case .toLogin:
            return .end(forwardToParentFlowWithStep: FlowStep.toLogin)
        default:
            return .none
        }
    }
    
    private func navigateToProjectList() -> FlowContributors {
        print(#function)
        return .one(flowContributor: .contribute(withNext: rootViewController))
    }
}
class TaskFlowStepper:Stepper{
    var steps = PublishRelay<Step>()
}
