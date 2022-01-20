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
    
    var statusModel: Status = Status() {
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
        taskListService.fetchStatusColumnList { [weak self] status in
            guard let self = self else { return }
            self.statusModel = status
        }
    }
    
    func makeTaskListViewController(statusIndex: Int = 0) -> TaskListVC? {
        if statusIndex > self.statusModel.columns.count {
            return nil
        }
        
        let taskListViewController = TaskListVC()
        taskListViewController.taskListViewModel.statusIndex = statusIndex
        taskListViewController.taskListViewModel.status = statusModel.columns[statusIndex]
        taskListViewController.taskListViewModel.taskModel.columnByStatus = statusModel.tasks
        
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
            return nil
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
        
        if nextIndex == self.statusModel.columns.count - 1 {
            return nil
        } else {
            nextIndex += 1
        }

        return self.makeTaskListViewController(statusIndex: nextIndex)
    }
    
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return self.statusModel.columns.count
//    }
//    
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        return 0
//    }
}
