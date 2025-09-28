//
//  InventoeryListServices.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 17/08/25.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore

struct InventoryListServices: InventoryListServiceProtocol {

    private var db: Firestore { Firestore.firestore() }
    
    func fetchInventory() async throws -> [InventoryItemModel] {
     
        let snapshot = try await db.collection("Inventories").getDocuments()
        let inventories = try snapshot.documents.compactMap { doc in
            try doc.data(as: InventoryItemModel.self)
        }
        return inventories
        
    }
    
    func removedInventory(id: String) async throws {
        try await db.collection("Inventories").document(id).delete()
    }

}
