//
//  TaskListVC.swift
//  ChatUIProject
//
//  Created by Zoe on 2022/01/06.
//

import UIKit
import FlexLayout
import PinLayout

class TaskListVC: UIViewController {
    
    // MARK: - Properties
    
    var kanbanTableView: UITableView = UITableView()
    
    let taskListViewModel = TaskListViewModel()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TaskListController"
        
        view.backgroundColor = .white
        
        initKanbanTableView()
        taskListViewModel.onUpdated = { [weak self] in
            DispatchQueue.main.async {
                
            }
        }
        taskListViewModel.viewDidLoad()
        
    }
    
    // MARK: - Functions

    private func initKanbanTableView() {
        kanbanTableView.delegate = self
        kanbanTableView.dataSource = taskListViewModel
        kanbanTableView.separatorStyle = .none
                
        kanbanTableView.register(TaskListTableViewCell.self,
                                 forCellReuseIdentifier: TaskListTableViewCell.reuseIdentifier)
        kanbanTableView.estimatedRowHeight = 10 // for automaticDemension
        kanbanTableView.contentInsetAdjustmentBehavior = .always
        view.addSubview(kanbanTableView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        kanbanTableView.pin.all(PEdgeInsets(top: 10, left: 10, bottom: 0, right: 10))
    }

}

// MARK: - UITableViewDelegate

extension TaskListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // The UITableView will call the cell's sizeThatFit() method to compute the height.
        // WANRING: You must also set the UITableView.estimatedRowHeight for this to work.
        return UITableView.automaticDimension
    }
    
}
