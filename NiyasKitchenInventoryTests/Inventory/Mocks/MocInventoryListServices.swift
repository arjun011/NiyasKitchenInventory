//
//  MocInventoryListServices.swift
//  NiyasKitchenInventoryTests
//
//  Created by Arjun on 17/09/25.
//

import Testing
@testable import NiyasKitchenInventory
struct MocInventoryListServices: InventoryListServiceProtocol {

    var mockItems: [InventoryItemModel] = []
    func fetchInventory() async throws -> [InventoryItemModel] {
        return mockItems
    }

}
