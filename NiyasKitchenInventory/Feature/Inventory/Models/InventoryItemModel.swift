//
//  InventoryListModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 17/08/25.
//

import Foundation

struct InventoryItemModel: Identifiable {
    let id = UUID()
    let name: String
    let sku: String?
    let quantity: Double
    let unit: String
    let supplierName: String
    let lowStockThreshold: Double
    let lastUpdated: Date

    // Business state
    var isLowStock: Bool { quantity <= lowStockThreshold }
    var isStale: Bool {
        guard
            let sevenDaysAgo = Calendar.current.date(
                byAdding: .day, value: -7, to: Date())
        else { return false }
        return lastUpdated < sevenDaysAgo
    }

    // Presentation helper
    var formattedQuantity: String {
        quantity == floor(quantity)
            ? String(Int(quantity))
            : String(format: "%.1f", quantity)
    }

    var relativeDate: String {
        let r = RelativeDateTimeFormatter()
        r.unitsStyle = .short
        return r.localizedString(for: lastUpdated, relativeTo: Date())
    }
}

// MARK: - Mock data

let mockInventory: [InventoryItemModel] = [
    .init(
        name: "Tomatoes", sku: "VEG-001", quantity: 3, unit: "kg",
        supplierName: "Fresh Farms Ltd", lowStockThreshold: 5,
        lastUpdated: Date().addingTimeInterval(-2 * 60 * 60)),
    .init(
        name: "Paneer", sku: "DAI-201", quantity: 12, unit: "kg",
        supplierName: "DairyLand", lowStockThreshold: 5,
        lastUpdated: Date().addingTimeInterval(-24 * 60 * 60)),
    .init(
        name: "Milk", sku: "DAI-101", quantity: 1, unit: "L",
        supplierName: "Local Dairy", lowStockThreshold: 3,
        lastUpdated: Date().addingTimeInterval(-5 * 60 * 60)),
    .init(
        name: "Basmatī Rice", sku: "GRA-310", quantity: 48, unit: "kg",
        supplierName: "SpiceTrade Co.", lowStockThreshold: 10,
        lastUpdated: Date().addingTimeInterval(-10 * 24 * 60 * 60)),
]

