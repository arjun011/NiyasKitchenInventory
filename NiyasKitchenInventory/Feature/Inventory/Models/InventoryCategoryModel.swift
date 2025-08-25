//
//  InventoryCategoryModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 21/08/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct InventoryCategoryModel:Identifiable, Hashable, Codable {
    
    var id:UUID = UUID()
    var name:String
    var lowercasedName:String?
    
}

let mocInventoryCategory:[InventoryCategoryModel] = [.init(name: "Bar"), .init(name: "Vegetable"), .init(name: "Drinks") , .init(name: "Spices") , .init(name: "Packages")]
