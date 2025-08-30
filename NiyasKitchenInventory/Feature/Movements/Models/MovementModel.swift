//
//  MovementModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 29/08/25.
//

import Foundation
import FirebaseCore

struct MovementModel: Codable {
    var id:UUID = UUID()
    var itemId:String
    var itemName:String
    var type:String
    var quantity:Double
    var unitName:String
    var unitId:String
    var note:String?
    var supplierID:String?
    var supplierName:String?
    var createdAt:Date
    var createdBy:String
    
}
