//
//  MockAddEditInventoryServices.swift
//  NiyasKitchenInventoryTests
//
//  Created by Arjun on 18/09/25.
//

import Foundation
@testable import NiyasKitchenInventory

struct MockAddEditInventoryServices: AddEditInventoryServicesProtocol {
    
    var suppliers:[SupplierModel] = []
    func fetchSupplierList() async throws -> [SupplierModel] {
        return suppliers
    }
    
        
}
