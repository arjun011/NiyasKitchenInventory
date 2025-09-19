//
//  InventoeryCategoeryModel.swift
//  NiyasKitchenInventoryTests
//
//  Created by Arjun on 19/09/25.
//

import Foundation
@testable import NiyasKitchenInventory

extension InventoryCategoryModel {
    
    static func mock(id:UUID = UUID(), name:String = "name", lowercasedName:String = "Lowercasedname") -> InventoryCategoryModel {
        
        InventoryCategoryModel(id: id, name:name, lowercasedName: lowercasedName)
    }
}


