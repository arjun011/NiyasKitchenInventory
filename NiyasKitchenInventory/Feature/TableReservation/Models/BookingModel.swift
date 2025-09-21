//
//  BookingModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 20/09/25.
//

import Foundation

import Foundation
@preconcurrency import FirebaseFirestore

struct BookingModel: Codable, Identifiable, Sendable {
    @DocumentID var id: String?
    let name: String
    let phoneNumber: String
    let guests: Int
    let dateTime: Date
    let note: String?
    let createdAt: Timestamp
    let bookedBy:String
    var isToday: Bool {
        Calendar.current.isDateInToday(dateTime)
    }
    var displaydateTime:String {
        isToday ? dateTime.formatted(date: .omitted, time: .shortened) : dateTime.formatted(date: .abbreviated, time: .shortened)
    }
}
