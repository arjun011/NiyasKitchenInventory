//
//  AddEditInventoryServicesProtocol.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 18/09/25.
//

import Foundation

protocol AddEditInventoryServicesProtocol:Sendable {
    
    func fetchSupplierList() async throws -> [SupplierModel]
    
    func fetchUnits() async throws -> [UnitsModel]
    
    func saveInventory(inventory: InventoryItemModel) async throws -> InventoryItemModel
    
    func fetchCategoryList() async throws -> [InventoryCategoryModel]
    
    func saveCategory(category: InventoryCategoryModel) async throws -> InventoryCategoryModel
    
    func saveNewSupplier(newSupplier: SupplierModel) async throws -> SupplierModel
}
