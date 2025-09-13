//
//  POModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 04/09/25.
//

@preconcurrency import FirebaseFirestore
import Foundation

struct POModel: Codable, Identifiable, Sendable {
    @DocumentID var id: String?
    var supplierId: String
    var supplierName: String
    var supplierEmail: String
    var status: String  //(DRAFT | SENT | PARTIAL | RECEIVED | CLOSED | CANCELED)
    var expectedDate: Date?
    var lineCount: Int?
    var notes: String?
    var createdAt: Date?
    var createdBy: String?
    var sentAt: Date?
    var receivedAt: Date?
    var updatedAt: Date?
    var orderStatus: POStatus {
        return (POStatus(rawValue: status) ?? .all)
    }

    var dispalyDateOnDetails: Date? {
        switch orderStatus {

        case .all:      return expectedDate
        case .draft:    return expectedDate
        case .sent:     return expectedDate
        case .partial:  return receivedAt
        case .received: return receivedAt
        case .closed:   return updatedAt
        case .canceled: return updatedAt
        }
    }

}

nonisolated(unsafe) var mocPOModel = POModel(
    id: "queXcMwgYdXkFUF5PQZy",
    supplierId: "sdd",
    supplierName: "Giro",
    supplierEmail: "info@giro.com",
    status: POStatus.draft.rawValue)
