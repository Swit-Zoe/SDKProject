//
//  TaskList.swift
//  ChatUIProject
//
//  Created by Zoe on 2022/01/06.
//

import Foundation

// MARK: - TaskListData
struct TaskListData: Codable {
    let version: Double
    let data: TaskList
    let code: Int // status code
    let message: String
}

// MARK: - DataClass
struct TaskList: Codable {
    let views: Views
    let backlogs: [String] // backlog model 없어서 그냥 String 배열로 선언
    let columns: Columns
}

// MARK: - Views
struct Views: Codable {
    let assign: Assign
    let status: Status
    let bucket: Assign
}

// MARK: - Assign
struct Assign: Codable {
    let columns: [String]
    let tasks: AssignTasks
}

// MARK: - AssignTasks
struct AssignTasks: Codable {
}

// MARK: - Status
struct Status: Codable {
    let columns: [String]
    let tasks: [String: [String]]
    
    init() {
        self.columns = []
        self.tasks = [:]
    }
}

// MARK: - Columns
struct Columns: Codable {
    let done, doing, toDo: Doing

    enum CodingKeys: String, CodingKey {
        case done = "Done"
        case doing = "Doing"
        case toDo = "ToDo"
    }
}

// MARK: - Doing
struct Doing: Codable {
    let colName, colID: String

    enum CodingKeys: String, CodingKey {
        case colName = "col_name"
        case colID = "col_id"
    }
}
