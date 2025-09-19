//
//  MockAddEditInventoryServices.swift
//  NiyasKitchenInventoryTests
//
//  Created by Arjun on 18/09/25.
//

import Foundation
@testable import NiyasKitchenInventory

struct MockAddEditInventoryServices: AddEditInventoryServicesProtocol {
    
    var units:[UnitsModel] = []
    
    func fetchUnits() async throws -> [UnitsModel] {
        return units
    }
    
    var inventoryItems:InventoryItemModel?
    func saveInventory(inventory:InventoryItemModel) async throws -> InventoryItemModel {
        return inventoryItems ?? .mock()
    }
    
    var inventoeryCategory:[InventoryCategoryModel] = []
    func fetchCategoryList() async throws -> [InventoryCategoryModel] {
        return inventoeryCategory
    }
    
    var savedInventoeryCategoery:InventoryCategoryModel?
    func saveCategory(category:InventoryCategoryModel) async throws -> InventoryCategoryModel {
        
        savedInventoeryCategoery ?? .mock()
    }
    
    var supplier:SupplierModel?
    func saveNewSupplier(newSupplier: NiyasKitchenInventory.SupplierModel) async throws -> SupplierModel {
        return supplier ?? .mock()
    }
    
    
    var suppliers:[SupplierModel] = []
    func fetchSupplierList() async throws -> [SupplierModel] {
        return suppliers
    }
    
}
