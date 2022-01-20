//
//  Task.swift
//  ChatUIProject
//
//  Created by Zoe on 2022/01/06.
//

import Foundation

typealias Tasks = [String: Task]

// MARK: - TaskData
struct TaskData: Codable {
    let timestamp: String
    let code: Int
    let message: String
    let version: Double
    let xsoc: Int? // 자료형 몰라서 Optional(Int)로 선언, 데이터 파일엔 null로 오고 있음
    let data: Tasks
}

// MARK: - Datum
struct Task: Codable {
    let created: String
    let followerList: [String]
    let logDesc, logEdt: String
    let logStatus: String
    let priority: String
    let logColor: String
    let logID, logTitle, userID: String
    let prjID: String
    let bookmarkYn: Bool? // 자료형 몰라서 Optional(Bool)로 선언, 데이터 파일엔 null로 오고 있음
    let checklistAllCnt: Int
    let logSdt: String
    let commentCnt: Int
    let tagList: [String]
    let thumbnail: String?
    let colID: String
    let memberList: [String] // "unassign"
    let checklistDoneCnt, assetsCnt: Int

    enum CodingKeys: String, CodingKey {
        case created, followerList
        case logDesc = "log_desc"
        case logEdt = "log_edt"
        case logStatus = "log_status"
        case priority
        case logColor = "log_color"
        case logID = "log_id"
        case logTitle = "log_title"
        case userID = "user_id"
        case prjID = "prj_id"
        case bookmarkYn = "bookmark_yn"
        case checklistAllCnt = "checklist_all_cnt"
        case logSdt = "log_sdt"
        case commentCnt = "comment_cnt"
        case tagList, thumbnail
        case colID = "col_id"
        case memberList
        case checklistDoneCnt = "checklist_done_cnt"
        case assetsCnt = "assets_cnt"
    }
}
