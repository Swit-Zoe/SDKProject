//
//  KanbanViewModel.swift
//  ChatUIProject
//
//  Created by Zoe on 2022/01/19.
//

import Foundation
import UIKit

class KanbanViewModel: NSObject {
    
    // MARK: - Properties
    
    var onUpdated: () -> Void = {}
    
    var statusModel: StatusModel = StatusModel() {
        didSet {
            onUpdated()
        }
    }
    
    let taskListService = TaskListService()
    
    // MARK: - View Life Cycle
    
    func viewDidLoad() {
        reload()
        // make default view controller
    }
    
    // MARK: - Functions
    
    func reload() {
        taskListService.fetchStatusList { [weak self] model in
            guard let self = self else { return }
            self.statusModel = model
        }
    }
    
    func makeTaskListViewController(statusIndex: Int) -> TaskListVC? {
        if statusIndex > self.statusModel.status.count {
            return nil
        }
        
        let taskListViewController = TaskListVC()
        taskListViewController.taskListViewModel.statusIndex = statusIndex
        
        return taskListViewController
    }
}

extension KanbanViewModel: UIPageViewControllerDelegate {
    
}

extension KanbanViewModel: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let prevViewController = viewController as? TaskListVC else {
            return nil
        }
        
        var previousIndex = prevViewController.taskListViewModel.statusIndex
        
        if previousIndex == 0 {
            previousIndex = 2 //self.statusModel.status.count - 1
        } else {
            previousIndex -= 1
        }

        return self.makeTaskListViewController(statusIndex: previousIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let nextViewController = viewController as? TaskListVC else {
            return nil
        }
        
        var nextIndex = nextViewController.taskListViewModel.statusIndex
        
        if nextIndex == 2 { //self.statusModel.status.count - 1 {
            nextIndex = 0
        } else {
            nextIndex += 1
        }

        return self.makeTaskListViewController(statusIndex: nextIndex)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 3 // self.statusModel.status.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
