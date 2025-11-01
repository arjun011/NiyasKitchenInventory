//
//  SupplierModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 20/08/25.
//

import Foundation
import FirebaseCore
@preconcurrency import FirebaseFirestore


// MARK: - Mock Supplier model (static for now)
struct SupplierModel: Identifiable, Hashable , Codable, Sendable{
    @DocumentID var id:String?
    var name: String
    var lowercasedName:String?
    var phone: String?
    var email: String?
    var createdAt:Timestamp?
    var updatedAt:Timestamp?
}

 let mockSuppliersSeed: [SupplierModel] = [
    .init(name: "Fresh Farms Ltd", phone: "+44 7123 456789", email: "contact@freshfarms.com"),
    .init(name: "DairyLand", phone: "+44 7000 111222", email: "info@dairyland.com"),
    .init(name: "SpiceTrade Co.", phone: nil, email: "hello@spicetrade.co")
]
