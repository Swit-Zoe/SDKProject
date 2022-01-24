//
//  Date+Extension.swift
//  ChatUIProject
//
//  Created by park kevin on 2022/01/20.
//

import Foundation

public extension DateFormatter {
    static let createdDateFormat : DateFormatter = {
       let df = DateFormatter()
        df.locale = Locale(identifier: Locale.preferredLanguages[0])
        df.dateFormat = "a h:mm"
        return df
    }()
    
    static let dayDateFormat : DateFormatter = {
       let df = DateFormatter()
        df.locale = Locale(identifier: Locale.preferredLanguages[0])
        df.dateFormat = "MM dd EEEE"
        return df
    }()
}

public extension Date {
    func getCreatedTimeString()->String{
        return DateFormatter.createdDateFormat.string(from: self)
    }
    
    func getDayTimeString()->String{
        return DateFormatter.dayDateFormat.string(from: self)
    }
}
