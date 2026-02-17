//
//  AllergenceDishProtocol.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 11/02/26.
//

import Foundation
import Firebase

protocol AllergenceDishProtocol: Sendable {
    
    var db:Firestore {
        get
    }
    
    func saveAllergens(allergens: AllergensModel) async throws
    
    func checkDishNameExists(dishName:String) async throws
    
    func getDishList() async throws -> [AllergensModel]
    
    func updateAllergensDetails(allergens: AllergensModel) async throws
}
