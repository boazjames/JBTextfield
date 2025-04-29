//
//  File.swift
//  
//
//  Created by Boaz James on 21/07/2023.
//

import Foundation

extension Date {
    func commonDateFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        formatter.locale = Locale(identifier: Locale.current.languageCode ?? "en")
        return formatter.string(from: self)
    }
    
    func commonServerDateFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: Locale.current.languageCode ?? "en")
        return formatter.string(from: self)
    }
    
    func commonDateTimeFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy h:mma"
        formatter.locale = Locale(identifier: Locale.current.languageCode ?? "en")
        return formatter.string(from: self)
    }
    
    func commonServerDateTimeFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.locale = Locale(identifier: Locale.current.languageCode ?? "en")
        return formatter.string(from: self)
    }
    
    func formatDate(formatString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = formatString
        formatter.locale = Locale(identifier: Locale.current.languageCode ?? "en")
        return formatter.string(from: self)
    }
    
    static func parseCreditCardExpiryDate(dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yy"
        if #available(iOS 16, *) {
            formatter.locale = Locale(identifier: Locale.current.language.languageCode?.identifier ?? "en")
        } else {
            formatter.locale = Locale(identifier: Locale.current.languageCode ?? "en")
        }
        return formatter.date(from: dateString)
    }
    
    func creditCardExpiryDateFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yy"
        formatter.locale = Locale(identifier: Locale.current.languageCode ?? "en")
        return formatter.string(from: self)
    }
    
    func midnight(using calendar: Calendar = .current) -> Date {
        calendar.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
}
