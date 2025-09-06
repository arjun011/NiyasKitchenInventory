//
//  POItmsModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 02/09/25.
//

import Foundation
import FirebaseFirestore
struct POLineModel: Codable, Identifiable, Hashable {

    @DocumentID var id: String? 
    var itemName: String
    var unitName: String
    var receivedQty: Double?
    var lastReceivedAt: Date?
    var lowStockThreshold: Double?
    var orderedQty: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case itemName = "name"
        case unitName = "unit"
        case receivedQty, lastReceivedAt, lowStockThreshold,orderedQty

    }

}
