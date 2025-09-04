//
//  POServices.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 02/09/25.
//

import Foundation
import Firebase

class POServices {
    
    enum POServicesError:LocalizedError{
        case itemsNotFound
        
      var errorDescription: String? {
            switch self {
            case .itemsNotFound: return "Inventory not found"
            }
        }
    }
    
    private let db = Firestore.firestore()
    
    func getInventoriesBy(supplierID: String) async throws -> [POItemsModel]  {
        
        let snapshot = try await db.collection("Inventories").whereField(
            "supplierId", isEqualTo: supplierID).getDocuments()
        
        
        guard !snapshot.isEmpty else {
            throw POServicesError.itemsNotFound
        }
        
        let inventoryList = try snapshot.documents.compactMap { doc in
            return try doc.data(as: POItemsModel.self)
        }
        
        return inventoryList
        
    }
    
    
}
