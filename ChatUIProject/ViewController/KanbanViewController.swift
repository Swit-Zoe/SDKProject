//
//  KanbanViewController.swift
//  ChatUIProject
//
//  Created by Zoe on 2022/01/19.
//

import UIKit

class KanbanViewController: UIViewController {
    
    // MARK: - Properties
    
    var statusName: String = ""
    var kanbanViewModel = KanbanViewModel()
    
    // MARK: UI Objects
    
    var pageViewController: UIPageViewController?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "KanbanViewController"

        initPageViewController()
        kanbanViewModel.viewDidLoad()
        assignDelegation()
        setInitialViewController()
    }
    
    // MARK: - Functions
    
    private func assignDelegation() {
        pageViewController?.delegate = kanbanViewModel
        pageViewController?.dataSource = kanbanViewModel
    }
    
    private func setInitialViewController() {
        if let initialViewController = kanbanViewModel.makeTaskListViewController(statusIndex: 0),
           let pageViewController = pageViewController {
            pageViewController.setViewControllers([initialViewController],
                                                  direction: .reverse,
                                                  animated: true,
                                                  completion: nil)
        }
    }
    
    func initPageViewController() {
        let pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                      navigationOrientation: .horizontal,
                                                      options: nil)
        pageViewController.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        
        self.pageViewController = pageViewController
        
        self.view.addSubview(pageViewController.view)
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
    }

}
