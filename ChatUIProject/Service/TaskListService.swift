//
//  TaskListService.swift
//  ChatUIProject
//
//  Created by Zoe on 2022/01/11.
//

import Foundation
import SwiftUI

class TaskListLoader {
    
    // load data from json
    func loadDataFromJson<T: Decodable>(type: T.Type, resource: String) -> T? {
        guard let fileURL = Bundle.main.url(forResource: resource, withExtension: "json") else { return nil }
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(type.self, from: data) else {
            return nil
        }
        return decodedData
    }
    
}

class TaskListService {
    
    var taskListLoader = TaskListLoader()
    
    var status = StatusModel()
    var model = TaskListModel()
    
    func fetchStatusList(onCompleted: @escaping (StatusModel) -> Void) {
        guard let statusData = taskListLoader.loadDataFromJson(type: TaskListData.self, resource: "column") else {
        return }
        /// 210119 작업 중, push for meeting
    }
    
    func fetchData(onCompleted: @escaping (TaskListModel) -> Void) {
        
        guard let taskListData = taskListLoader.loadDataFromJson(type: TaskListData.self, resource: "column") else { return }
        let statusList = taskListData.data.views.status.columns
        let allTasks = taskListData.data.views.status.tasks
        
        model.status = statusList
        
        statusList.forEach { status in
            guard let columns = allTasks[status] else { return }
            var tasks: [Task] = []
            
            columns.forEach { column in
                guard let task: Task = getTask(logId: column) else { return }
                tasks.append(task)
            }
            
            model.taskByStatus[status] = tasks
        }
        
        onCompleted(model)
    }
    
    // find task from task list
    func getTask(logId: String) -> Task? {
        
        guard let taskData = taskListLoader.loadDataFromJson(type: TaskData.self, resource: "tasks") else { return nil }
        guard let task = taskData.data[logId] else { return nil }
        
        return task
    }
}
