//
//  ChatListService.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/22.
//

import Foundation
import RxSwift

class ChatListService{
    
    var chatRepo:ChatList?
    let chatList = PublishSubject<ChatList>()
    var disposeBag = DisposeBag()

    
    //MARK: fetch json file
    func fetchRepo(path: String){
        let decoder = JSONDecoder()
        let df = DateFormatter()
        df.locale = Locale(identifier: Locale.preferredLanguages[0])
        df.calendar = Calendar(identifier: .iso8601)
        
        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)

            df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            guard let date = df.date(from: dateStr) else{
                return Date()
            }
            return date
        })
        
        guard let fileURL = Bundle.main.url(forResource: path, withExtension: "json") else { return }
        guard let data = try? Data(contentsOf: fileURL) else { return }
        chatRepo = try? decoder.decode(ChatList.self, from: data)
        
        if let chatRepo = chatRepo {
            chatList.onNext(chatRepo)
        }
        
    }
}
