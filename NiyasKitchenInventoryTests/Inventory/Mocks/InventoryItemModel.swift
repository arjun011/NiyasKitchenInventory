//
//  InventoryItemModel.swift
//  NiyasKitchenInventoryTests
//
//  Created by Arjun on 17/09/25.
//

import Testing
import Foundation
@testable import NiyasKitchenInventory
extension InventoryItemModel {
    
    static func mock(name:String = "ItemName", quantity:Double = 11.3, unit:String = "KG", supplierName:String = "Giro", lowStockThreshold:Double = 10, updatedAt:Date = Date()) -> InventoryItemModel {
        
        return InventoryItemModel(id: UUID(), name: name, quantity: quantity, unit: unit, supplierName: supplierName, lowStockThreshold: lowStockThreshold, updatedAt: updatedAt)
    }

}
