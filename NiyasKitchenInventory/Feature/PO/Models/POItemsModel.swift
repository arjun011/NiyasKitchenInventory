//
//  POItmsModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 02/09/25.
//

import Foundation

struct POItemsModel: Codable, Identifiable, Hashable {

    var id: UUID = UUID()
    var itemName: String
    var unitName: String
    var receivedQty: Double?
    var lastReceivedAt: Date?
    var lowStockThreshold: Double?

    private var _orderedQty: Double?

    var orderedQty: Double {
        get { _orderedQty ?? (lowStockThreshold ?? 0) * 2 }
        set { _orderedQty = newValue }
    }

    enum CodingKeys: String, CodingKey {
        case id
        case itemName = "name"
        case unitName = "unit"
        case _orderedQty = "orderedQty"
        case receivedQty, lastReceivedAt, lowStockThreshold

    }

}
