//
//  ChatData2.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/06.
//

import Foundation
import RealmSwift

class ChatModel:Object{
    @objc dynamic var name:String?
    @objc dynamic var content:String?
    @objc dynamic var time:Date?
}
