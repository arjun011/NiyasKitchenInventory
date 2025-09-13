//
//  MovementsServices.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 29/08/25.
//

import Foundation
import Firebase
struct MovementsServices : Sendable{
    
    enum GeneralError: LocalizedError {
        case inventoryMissing(String)
        case duplicateName(String)
        case firestore(String)
        case wouldGoNegative

        var errorDescription: String? {
            switch self {
            case .inventoryMissing(let name) :
                return "\(name) inventory missing"
            case .duplicateName(let name):
                return "A \(name) already exists."
            case .wouldGoNegative:
                return "Quantity would go negative"
            case .firestore(let msg): return msg
            }
        }
    }

    private var db:Firestore {Firestore.firestore() }
    
    
    func fetchMovements() async throws -> [MovementModel] {
        
        let snapshot = try await db.collection("Movements").getDocuments()
        let movenemts = try snapshot.documents.compactMap { doc in
            try doc.data(as: MovementModel.self)
        }
        return movenemts
        
    }
    
    
    func saveMovement(movement: MovementModel) async throws  -> MovementModel{
        
        try await self.updateInventory(movement: movement)
        let docRef = db.collection("Movements").document()
        try docRef.setData(from: movement, merge: false)
        
        try await docRef.updateData([
            "createdAt": FieldValue.serverTimestamp()
        ])
        
        // 4) Read back (optional) or map locally
        let snap = try await docRef.getDocument()
        return try snap.data(as: MovementModel.self)
        
    }
    
    
    private func updateInventory(movement: MovementModel) async throws {
        
        let docRef = db.collection("Inventories").document(movement.itemId)
        let snap = try await docRef.getDocument()
        
        guard snap.exists else {
            throw GeneralError.inventoryMissing(movement.itemName)
        }
        
        let inventoryResult = try snap.data(as: InventoryItemModel.self)
        
        let quntity = movement.type == MovementType.in.rawValue ? movement.quantity : (-movement.quantity)
        
        let actualQuantity = inventoryResult.quantity + (quntity)
        
        guard actualQuantity >= 0  else {
            throw GeneralError.wouldGoNegative
        }
        
        try await docRef.updateData([
            "quantity": actualQuantity,
            "updatedAt": FieldValue.serverTimestamp()
        ])
        
    }
    
    func countWastMovementsSince(_ date: Date) async throws -> Int {
            let snapshot = try await db.collection("Movements")
            .whereField("createdAt", isGreaterThanOrEqualTo: Timestamp(date: date)).whereField("type", isEqualTo: MovementType.waste.rawValue)
                .getDocuments()

            return snapshot.documents.count
        }
    
}
