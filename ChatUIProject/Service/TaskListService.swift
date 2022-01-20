//
//  TaskListService.swift
//  ChatUIProject
//
//  Created by Zoe on 2022/01/11.
//

import Foundation
import SwiftUI

class JSONLoader {
    
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
    
    var taskListLoader = JSONLoader()
    
    // column.json
    func fetchStatusColumnList(onCompleted: @escaping (Status) -> Void) {
        guard let taskListData = taskListLoader.loadDataFromJson(type: TaskListData.self,
                                                                 resource: "column") else {
            return
        }
        let status: Status = taskListData.data.views.status
        onCompleted(status)
    }
    
    // tasks.json
    func fetchTaskList(onCompleted: @escaping (Tasks) -> Void) {
        guard let taskData = taskListLoader.loadDataFromJson(type: TaskData.self,
                                                             resource: "tasks") else {
            return
        }
        let tasks: Tasks = taskData.data
        onCompleted(tasks)
    }
}
