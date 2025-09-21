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
    var name: String
    var phoneNumber: String
    var guests: Int
    var dateTime: Date
    var note: String?
    var createdAt: Timestamp
    var bookedBy:String
}
