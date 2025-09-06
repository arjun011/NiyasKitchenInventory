//
//  POModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 04/09/25.
//

import Foundation
import FirebaseFirestore

struct POModel:Codable {
    @DocumentID var id: String?
    var supplierId: String
    var supplierName: String
    var supplierEmail: String
    var status: String //(DRAFT | SENT | PARTIAL | RECEIVED | CLOSED | CANCELED)
    var expectedDate: Date?
    var notes: String?
    var createdAt: Date?
    var createdBy: String?
    var sentAt: Date?
    var receivedAt: Date?
    var updatedAt:Date?
}
