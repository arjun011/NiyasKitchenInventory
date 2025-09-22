//
//  DateExtension.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 22/09/25.
//

import Foundation

extension Date {
    
    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = .current
        return formatter.string(from: self)
    }
    
    static var yesterday: Date? {
        Calendar.current.date(byAdding: .day, value: -1, to: Date())
    }
}
