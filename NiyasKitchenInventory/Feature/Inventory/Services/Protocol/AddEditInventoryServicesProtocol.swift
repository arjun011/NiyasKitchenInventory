//
//  AddEditInventoryServicesProtocol.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 18/09/25.
//

import Foundation

protocol AddEditInventoryServicesProtocol:Sendable {
    
    func fetchSupplierList() async throws -> [SupplierModel]
}
