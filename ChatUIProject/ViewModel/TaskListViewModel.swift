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
    var tasks: TaskListModel = TaskListModel() {
        didSet {
            onUpdated()
        }
    }
    
    let taskListService = TaskListService()
    
    func viewDidLoad() {
        reload()
    }
    
    func reload() {
        taskListService.fetchData { [weak self] model in
            guard let self = self else { return }
            self.tasks = model
        }
    }
}

//extension TaskListViewModel: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//}

extension TaskListViewModel {
    
    func numberOfRowsInSection(statusIdx: Int) -> Int {
        if statusIdx > tasks.status.count { return 0 }
        
        let status: String = tasks.status[statusIdx]
        return tasks.taskByStatus[status]?.count ?? 0
    }
    
    func taskAtIndex(statusIdx: Int, index: Int) -> Task {
        let status: String = tasks.status[statusIdx]
        return tasks.taskByStatus[status]![index]
    }
    
    func cellForRowAt(statusIdx: Int, index: Int) -> UITableViewCell {
        let cell = TaskListTableViewCell()
        cell.setCell(task: taskAtIndex(statusIdx: statusIdx, index: index))
        
        return cell
    }
}
