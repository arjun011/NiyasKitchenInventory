//
//  MockInventoryListServices.swift
//  NiyasKitchenInventoryTests
//
//  Created by Arjun on 16/09/25.
//

import Foundation

protocol InventoryListServiceProtocol: Sendable {
    
    func fetchInventory() async throws -> [InventoryItemModel]
}
