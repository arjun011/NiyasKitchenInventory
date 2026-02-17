//
//  AllergensDishServices.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 09/02/26.
//

import Foundation
import Firebase

struct AllergensDishServices: AllergenceDishProtocol {
    
    
    var db:Firestore {
        Firestore.firestore()
    }
    
    enum GeneralError: LocalizedError {
        case duplicateName(String)
        case firestore(String)

        var errorDescription: String? {
            switch self {
            case .duplicateName(let name):
                return "A \(name) already exists."
            case .firestore(let msg): return msg
            }
        }
    }
    
    func saveAllergens(allergens: AllergensModel) async throws {
        
        
        try await checkDishNameExists(dishName: allergens.dishName)
        let doc = db.collection("allergens").document()
        var draft = allergens
        draft.id = doc.documentID
        draft.dishNameNormalized = allergens.dishName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        try doc.setData(from: draft, merge: false)
        
    }
    
    
    func updateAllergensDetails(allergens: AllergensModel) async throws {
        
        guard let id = allergens.id, !id.isEmpty else {
            throw GeneralError.firestore("Missing document id for update.")
        }
        let doc = db.collection("allergens").document(id)
        var draft = allergens
        draft.id = id
        draft.dishNameNormalized = allergens.dishName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        try doc.setData(from: draft, merge: false)
    }
    
    
    
    func checkDishNameExists(dishName:String) async throws {
        
        let snapshot = try await db.collection("allergens").whereField(
            "dishNameNormalized", isEqualTo: dishName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        ).getDocuments()

        
        guard snapshot.isEmpty else {
            throw GeneralError.duplicateName(dishName)
        }
        
    }
    
    
    func getDishList() async throws -> [AllergensModel] {
        
        let snapshot = try await db.collection("allergens").getDocuments()
        let dishList = try snapshot.documents.compactMap { doc in
            try doc.data(as: AllergensModel.self)
        }
        return dishList
    }
}

