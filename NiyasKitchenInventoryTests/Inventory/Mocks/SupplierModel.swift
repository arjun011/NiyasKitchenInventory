//
//  SupplierModel.swift
//  NiyasKitchenInventoryTests
//
//  Created by Arjun on 18/09/25.
//

import Foundation
@testable import NiyasKitchenInventory
import FirebaseCore

extension SupplierModel {
    
    static func mock(id:UUID = UUID(), name:String = "name", phone:String = "01231233", email:String = "info@gmail.com", createdAt:Date = Date(), updatedAt: Date = Date()) -> SupplierModel {
        
        SupplierModel(id: UUID(), name: name,
                      phone: phone,
                      email: email,
                      createdAt: Timestamp(date: createdAt),
                      updatedAt: Timestamp(date: updatedAt))
    }
    
}
