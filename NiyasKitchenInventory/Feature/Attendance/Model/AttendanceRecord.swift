//
//  AttendanceRecord.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 19/09/25.
//

import Foundation

struct AttendanceRecord: Codable, Identifiable, Sendable {
    var id = UUID()
    let date: Date
    let status: Status
    let duration: TimeInterval?

    enum Status: String, Codable {
        case present
        case missedPunchOut
    }

    var isIrregular: Bool {
        status == .missedPunchOut
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    var formattedDuration: String {
        guard let duration = duration else { return "-" }
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        return "\(hours)h \(minutes)m"
    }
}
