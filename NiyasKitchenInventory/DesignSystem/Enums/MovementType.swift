//
//  MovementType.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 30/08/25.
//

import Foundation

enum MovementType: String, CaseIterable , Identifiable {
    var id: String {
        rawValue
    }
    
    case  `in` = "IN", out = "OUT", waste = "WASTE"
}
