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

struct ViewModel:Differentiable,Hashable{
    
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
    var messageData:[MessageDatum]?
    
    init(chat:Chat){
        self.text = RichTextConverter.shared.convertRichText(chat: chat)
        self.created = chat.created.getCreatedTimeString()
        self.modified = chat.modified.getCreatedTimeString()
        self.userName = chat.userName
        self.userID = chat.userID
        self.bodyText = chat.bodyText
        self.chatType = chat.chatType.rawValue
        self.reactions = chat.reactions
        self.msgCmtCnt = chat.msgCmtCnt
        
        self.ogData = chat.ogData
        self.isOutcome = chat.isOutcome
        self.messageData = chat.messageData
        self.assetData = chat.assetData
    }
    
    var differenceIdentifier: Self {
        return self
    }
    
    func isContentEqual(to source: ViewModel) -> Bool {
        return ((created == source.created) && (modified == source.modified)) ? true : false
    }
    
    static func == (lhs: ViewModel, rhs: ViewModel) -> Bool {
        return ((lhs.created == rhs.created) && (lhs.modified == rhs.modified)) ? true : false
    }
    func hash(into hasher: inout Hasher) {
//        hasher.combine(x)
//        hasher.combine(y)
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
        
            
        // Differnece Kit Test Timer
//            Timer.scheduledTimer(withTimeInterval: 5, repeats: true) {[weak self] timer in
//                guard let self = self else {return}
//                if self.viewModel.count > 1{
//                    let rand = Int.random(in: 0..<self.viewModel.count)
//                    self.viewModel.remove(at: rand)//.removeLast()
//                    self.chatViewModel.onNext(self.viewModel)
//                }else{
//                    timer.invalidate()
//                }
//                print("delete random row")
//            }
        
    }
    func fetchRepo(){
        model.fetchRepo()
    }
}

