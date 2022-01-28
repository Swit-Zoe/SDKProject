//
//  ChatListVC.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/06.
//

import Foundation
import UIKit
import SnapKit
import RxFlow
import RxCocoa
import RxSwift

class ChatListVC:UINavigationController,Stepper{
    var steps: PublishRelay<Step> = PublishRelay<Step>()
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorColor = .systemGray5
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // self.navigationController?.isNavigationBarHidden = true
    }
    
}
extension ChatListVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel!.text = "Channel\(indexPath.row + 1)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.steps.accept(FlowStep.toInChat(withChannelID: indexPath.row))
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}
