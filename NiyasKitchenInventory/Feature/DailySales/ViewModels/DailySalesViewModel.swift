//
//  DailySalesViewModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 20/09/25.
//

import Foundation
import Firebase
@MainActor
@Observable final class DailySalesViewModel {
    
     var card: Double = 0.0
     var cash: Double = 0.0
     var justEat: Double = 0.0
     var uberEats: Double = 0.0
     var bank: Double = 0.0
     var hasSubmittedToday: Bool = false

    var total: Double {
        card + cash + justEat + uberEats + bank
    }

    private var db: Firestore { Firestore.firestore() }

    func checkIfAlreadySubmitted() async {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let datePath = dateFormatter.string(from: Date())

        do {
            let doc = try await db
                .collection("dailySales")
                .document(datePath)
                .getDocument()

            hasSubmittedToday = doc.exists
        } catch {
            print("Error checking existing sales: \(error.localizedDescription)")
        }
    }

    func saveEntry(for userId: String) async throws {
        guard !hasSubmittedToday else { return }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let datePath = dateFormatter.string(from: Date())

        let data: [String: Any] = [
            "card": card,
            "cash": cash,
            "justEat": justEat,
            "uberEats": uberEats,
            "bank": bank,
            "total": total,
            "createdBy":userId,
            "timestamp": FieldValue.serverTimestamp()
        ]

        try await db
            .collection("dailySales")
            .document(datePath) // ✅ one entry per day
            .setData(data)

        hasSubmittedToday = true
    }
}
