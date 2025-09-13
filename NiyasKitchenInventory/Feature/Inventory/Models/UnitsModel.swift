//
//  UnitsModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 22/08/25.
//

import Foundation
@preconcurrency import FirebaseFirestore
struct UnitsModel: Identifiable, Codable, Hashable, Sendable {
    @DocumentID var id: String?
    var name:String
    
}

