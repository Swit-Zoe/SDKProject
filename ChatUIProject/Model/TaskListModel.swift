//
//  TaskListModel.swift
//  ChatUIProject
//
//  Created by Zoe on 2022/01/11.
//

import Foundation

struct TaskListModel {
    var status: [String] = []
    
    var taskByStatus: [String: [Task]] = [:]
}
