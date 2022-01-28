//
//  TableView+Extension.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/27.
//

import Foundation
import UIKit

extension UITableView {

    func hasRowAtIndexPath(indexPath: NSIndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}
