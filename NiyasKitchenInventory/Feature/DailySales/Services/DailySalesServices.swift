//
//  DailySalesServices.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 22/09/25.
//

import Foundation
import Firebase

struct DailySalesServices: Sendable {
    
    var db:Firestore {
        Firestore.firestore()
    }
    
    
    func submitOpening(userId: String, denominations: [String : Int?], entry:[String: Any]) async throws {
        
        try await db.collection("sales").document(Date().toString()).setData(
            [
                "date": Date().toString(),
                "opening": entry,
            ], merge: true)
        
    }
    
    
    func submitClosing(userId: String, denominations: [String : Int?], entry:[String: Any]) async throws {
     
        try await db.collection("sales").document(Date().toString()).setData(
            [
                "closing": entry
            ], merge: true)
     
    }
}
