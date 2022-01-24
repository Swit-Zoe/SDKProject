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

class Converter{
    var initFinish = BehaviorRelay(value: false)
    var emojiDictionary:[String:[String:String]] = [:]
    
    init(){
        makeEmojiDictionary()
    }
    
    private func convertRichText(richText:String)->NSAttributedString{
        let data = Data(richText.utf8)
        let decoder = JSONDecoder()
        
        guard let result = try? decoder.decode(BodyBlockSkit.self, from: data) else {return .empty}
        guard let element = result.elements.first else {return .empty}
        
        var viewString = NSAttributedString(string: "")
        
        element.elements.forEach{
            viewString = viewString + $0.applyStyle(emojiDictionary:emojiDictionary)
        }
        
        return viewString
    }
    
    func convertToViewModel(chatList:ChatList,toChatViewModel:PublishSubject<ViewModel>) {
        chatList.data.forEach{
            let chatViewModel = ViewModel(text: convertRichText(richText: $0.bodyBlockskit),
                                          created:  $0.created.getCreatedTimeString(),
                                          modified: $0.modified.getCreatedTimeString(),
                                          userName: $0.userName,
                                          userId: $0.userID)
            toChatViewModel.onNext(chatViewModel)
        }
        initFinish.accept(true)
    }
    
    private func makeEmojiDictionary(){
        guard let fileURL = Bundle.main.url(forResource: "emoji", withExtension: "json") else { return }
        guard let data = try? Data(contentsOf: fileURL) else { return }
       // guard let jsonString = String(data:data,encoding: String.Encoding.utf8) else {return}
        
        emojiDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:[String:String]]
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
