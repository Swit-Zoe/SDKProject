//
//  ChatViewModel.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/06.
//

import Foundation
import DifferenceKit
import RxSwift
import RichString

struct ViewModel:Differentiable{
    var text:NSAttributedString?
    var created:String?
    var modified:String?
    var userName:String?
    var userID:String?
    
    var assetData: [AssetDatum]?
    var bodyBlockskit: String?
    var bodyText: String?
    var bookmarkYn: Bool?
    var chID: String?
    var chName: String?
    var clientID: String?
    var contID: String?
    var contType: String?
    var msgCmtCnt: Int?
    var notiJSON: NotiJSON?
    var ogData: [OgDatum]?
    var originMsgID: String?
    var pinID: String?
    var reactions: [Reaction]?
    var seq: String?
    var shareData: JSONNull?
    var chatType: String?
    var backlogData: [JSONAny]?
    var msgID:String?
    var isSocket : Bool?
    var isOutcome: Bool?
    var wsID: String?
    
    init(chat:Chat){
        self.text = convertRichText(chat: chat)
        self.created = chat.created.getCreatedTimeString()
        self.modified = chat.modified.getCreatedTimeString()
        self.userName = chat.userName
        self.userID = chat.userID
        self.bodyText = chat.bodyText
        self.chatType = chat.chatType.rawValue
        self.reactions = chat.reactions
        self.msgCmtCnt = chat.msgCmtCnt
    }
    
    var differenceIdentifier: String? {
        return created
    }
    
    func isContentEqual(to source: ViewModel) -> Bool {
        return ((created == source.created) && (modified == source.modified)) ? true : false
    }
    
    func convertRichText(chat:Chat)->NSAttributedString{
        let data = Data(chat.bodyBlockskit.utf8)
        let decoder = JSONDecoder()
        
        let dummy = chat.bodyText.fontSize(16).color(.label)
        
        guard let result = try? decoder.decode(BodyBlocksKit.self, from: data) else {return dummy}
        guard let elements = result.elements else {return dummy}
        guard let element = elements.first else {return dummy}
        
        var viewString = NSAttributedString(string: "")
        
        element.elements!.forEach{
            viewString = viewString + $0.applyStyle()
        }
        
        return viewString
    }
}


class ChatViewModelService{
    let model = ChatListModel()
    var viewModel:[ViewModel] = []
    let disposeBag = DisposeBag()
    let chatViewModel = BehaviorSubject<[ViewModel]>(value:[])
    
    init(){
        model.toChatViewModel
            .observe(on:/*MainScheduler.instance*/ConcurrentDispatchQueueScheduler(qos: .default))
            .subscribe(onNext:{[weak self] in
                guard let self = self else {return}
                self.viewModel.append($0)
                self.chatViewModel.onNext(self.viewModel)
            }).disposed(by: disposeBag)
        
        //        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {[weak self] timer in
        //            guard let self = self else {return}
        //            if self.viewModel.count > 1{
        //                self.viewModel.removeFirst()
        //                self.chatViewModel.onNext(self.viewModel)
        //            }else{
        //                timer.invalidate()
        //            }
        //        }
        
    }
    func fetchRepo(){
        model.fetchRepo()
    }
}

