//
//  ChatData.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/05.
//

import Foundation

struct CD{
    var name:String?
    let content:String?
    var time:String?
    var selfName = false
}

class ChatData{
    let name = ["Kevin","Albus","Harold","Charles","Zoe"]
    
    let contents = ["Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                         "when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets",
                         " containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                         "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters,",
                         "as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like)."]

    public var cd:[CD]?
    
    init(){
        generateRandomChatData()
        checkPrevious()
    }
    
    fileprivate func generateRandomChatData(){
        cd = [CD]()
    
        let df = DateFormatter()
        df.dateFormat = "HH:mm a"
        
        for _ in 0 ..< 100{
            let rn1 = Int.random(in: 0..<5)
            let rn2 = Int.random(in: 0..<5)
            cd?.append(CD(name:name[rn1],content:contents[rn2],time:df.string(from: Date())))
        }
    }
    
    fileprivate func checkPrevious(){
        var pN = cd?[0].name
        var pT = cd?[0].time
        if pN == MyInfo.shared.name{
            cd?[0].selfName = true
        }
        for i in 1..<100{
            if cd?[i].name == MyInfo.shared.name{
                cd?[i].selfName = true
            }
            
            if pN == cd?[i].name && pT == cd?[i].time{
                pN = cd?[i].name
                pT = cd?[i].time
                
                cd?[i].name = nil
                cd?[i].time = nil
            }else{
                pN = cd?[i].name
                pT = cd?[i].time
            }
       
        }
    }
}

