//
//  ChatViewModel.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/06.
//

import Foundation

struct ChatInfo{
    var name:String?
    let content:String?
    var time:String?
    var selfName = false
    var same = false
}

class ChatViewModel{

    var CI:[ChatInfo]?
    let df = DateFormatter()
    let ns = ["User1","User2","User3","User4","User5"]
    
    init(){
        CI = [ChatInfo]()
        df.locale = Locale(identifier: Locale.preferredLanguages[0])
        //df.setLocalizedDateFormatFromTemplate("a HH:mm")

        df.dateFormat = "a h:mm"
    }
    
    func add(chatModel:ChatModel){
        let t = df.string(from: chatModel.time!)
        let selfName = chatModel.name == MyInfo.shared.name ? true : false
        guard let ciLast = CI?.last else{
            let ci = ChatInfo(name: chatModel.name, content: chatModel.content, time: t,selfName: selfName)
            CI?.append(ci)
            return
        }
        
        let same = (ciLast.name == chatModel.name && ciLast.time == t)

        let ci = ChatInfo(name: chatModel.name, content: chatModel.content, time: t,selfName: selfName,same: same)
        CI?.append(ci)
        
        
    }
}

