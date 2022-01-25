//
//  ChatListModel.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/22.
//

import Foundation
import RxSwift
import RxRelay
import RichString
import UIKit

class Converter{
    var initFinish = BehaviorRelay(value: false)
    var previousData:Chat?
    
    func convertToViewModel(chatList:ChatList,toChatViewModel:PublishSubject<ViewModel>) {
        chatList.data.forEach{

            var viewModel = ViewModel(chat:$0)
            
            if let previousData = previousData {

                if previousData.created.getDayTimeString() != $0.created.getDayTimeString(){
                    var temp = ViewModel(chat:$0)
                    temp.userID = "_"
                    temp.chatType = "day"
                    temp.bodyText = $0.created.getDayTimeString()
                    temp.reactions = nil
                    temp.msgCmtCnt = nil
                    
                    toChatViewModel.onNext(temp)
                }
                
                if let notiJson = $0.notiJSON{
                    viewModel.notiJSON = notiJson
                    switch(notiJson.notiTempCode){
                    case .s010:
                        viewModel.bodyText = notiJson.notiValues.userName + " 님이 " + notiJson.notiValues.chName + " 채널에 입장했습니다."
                        break
                    case .s012:
                        viewModel.bodyText = notiJson.notiValues.userName + " 님이 " + notiJson.notiValues.chName + " 채널에서 퇴장했습니다."
                        break
                    }
                    toChatViewModel.onNext(viewModel)
                    self.previousData = $0
                    return
                }

                if previousData.created.getCreatedTimeString() == $0.created.getCreatedTimeString() &&
                    previousData.created.getDayTimeString() == $0.created.getDayTimeString() &&
                    previousData.userID == $0.userID{
                    viewModel.created = nil
                    viewModel.userName = nil
                }
                
            }
            
            toChatViewModel.onNext(viewModel)
            previousData = $0
        }
        initFinish.accept(true)
    }
}

class ChatListModel{
    let service = ChatListService()
    let disposeBag = DisposeBag()
    let converter = Converter()
    var toChatViewModel = PublishSubject<ViewModel>()
    
    init(){
        
        service.chatList.observe(on: MainScheduler.instance/*ConcurrentDispatchQueueScheduler(qos: .default)*/)
            .subscribe(onNext:{[weak self] in

                guard let self = self else {return}
                
                self.converter.convertToViewModel(chatList: $0,toChatViewModel: self.toChatViewModel)
          
            }).disposed(by:disposeBag)
        
        
    }
    func fetchRepo(){
        service.fetchRepo(path: "newschannel")
    }
}
