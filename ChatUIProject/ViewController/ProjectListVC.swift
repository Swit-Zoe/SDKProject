//
//  ChatListVC.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/06.
//

import Foundation
import UIKit
import SnapKit

class ProjectListVC:UIViewController{
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
}
extension ProjectListVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel!.text = "project\(indexPath.row + 1)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        present(nextVC, animated: true, completion: nil)
        let nextVC = KanbanViewController()
        nextVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}
