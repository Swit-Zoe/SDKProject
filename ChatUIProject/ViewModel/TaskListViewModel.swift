//
//  TaskListViewModel.swift
//  ChatUIProject
//
//  Created by Zoe on 2022/01/11.
//

import Foundation
import UIKit

class TaskListViewModel: NSObject {
    
    var onUpdated: () -> Void = {}
    
    var statusIndex: Int = 0
    var status: String = ""
    
    var taskModel: TaskListModel = TaskListModel() {
        didSet {
            onUpdated()
        }
    }
    
    let taskListService = TaskListService()
    
    func viewDidLoad() {
        reload()
    }
    
    func reload() {
        taskListService.fetchTaskList { [weak self] model in
            guard let self = self else { return }
            self.taskModel.tasks = model
        }
    }
}

extension TaskListViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskModel.columnByStatus[status]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskListTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? TaskListTableViewCell else {
            return UITableViewCell()
        }
        
        let logId = taskModel.columnByStatus[status]![indexPath.row]
        
        cell.setCell(task: taskModel.tasks[logId])
        
        return cell
    }
}
