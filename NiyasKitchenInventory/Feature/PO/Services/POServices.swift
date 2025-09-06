//
//  POServices.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 02/09/25.
//

import Firebase
import Foundation

class POServices {

    enum POServicesError: LocalizedError {
        case itemsNotFound

        var errorDescription: String? {
            switch self {
            case .itemsNotFound: return "Inventory not found"
            }
        }
    }

    private let db = Firestore.firestore()

    func getInventoriesBy(supplierID: String) async throws -> [POLineModel] {

        let snapshot = try await db.collection("Inventories").whereField(
            "supplierId", isEqualTo: supplierID
        ).getDocuments()

        guard !snapshot.isEmpty else {
            throw POServicesError.itemsNotFound
        }

        let inventoryList = try snapshot.documents.compactMap { doc in
            return try doc.data(as: POLineModel.self)
        }

        return inventoryList

    }

    func saveDraft(orderDraft: POModel, lines:[POLineModel]) async throws  {

        let doc = db.collection("purchaseOrders").document()
        var draft = orderDraft
        draft.id = doc.documentID

        try doc.setData(from: draft, merge: false)

        try await doc.updateData([
            "createdAt": FieldValue.serverTimestamp(),
            "updatedAt": FieldValue.serverTimestamp(),
        ])


        try await self.replaceLines(poId: doc.documentID, lines: lines)


    }

    func replaceLines(poId: String, lines: [POLineModel]) async throws {
        let col = db.collection("purchaseOrders").document(poId).collection(
            "lines")
        let batch = db.batch()

        // delete existing lines first (draft edit case)
        let existing = try await col.getDocuments()
        for doc in existing.documents { batch.deleteDocument(doc.reference) }

        // add new lines
        for line in lines {
            let docRef = col.document()
            var payload = line
            payload.id = docRef.documentID
            try batch.setData(from: payload, forDocument: docRef, merge: false)
        }

        try await batch.commit()
    }

}
