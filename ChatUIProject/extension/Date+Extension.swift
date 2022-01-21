//
//  Date+Extension.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/20.
//

import Foundation

public extension DateFormatter {
    static let commonDf : DateFormatter = {
       let df = DateFormatter()
        df.locale = Locale(identifier: Locale.preferredLanguages[0])
        df.dateFormat = "a h:mm"
        return df
    }()
}
