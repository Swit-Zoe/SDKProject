//
//  ChatViewModel.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/06.
//

import Foundation
import DifferenceKit
import RxSwift

struct ViewModel:Differentiable{
    var text:NSAttributedString
    var created:String
    var modified:String
    var userName:String
    var userId:String
    
    var differenceIdentifier: String {
           return created
       }

   func isContentEqual(to source: ViewModel) -> Bool {
       return ((created == source.created) && (modified == source.modified)) ? true : false
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
                        print("chat Element Count = \(self.viewModel.count)")
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

