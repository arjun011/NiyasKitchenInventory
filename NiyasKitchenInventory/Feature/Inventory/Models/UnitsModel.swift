//
//  UnitsModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 22/08/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
struct UnitsModel: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var name:String
    
}

