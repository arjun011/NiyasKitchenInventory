//
//  POServices.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 02/09/25.
//

import Firebase
import Foundation

struct POServices: Sendable {

    enum POServicesError: LocalizedError {
        case itemsNotFound

        var errorDescription: String? {
            switch self {
            case .itemsNotFound: return "Inventory not found"
            }
        }
    }

    private var db:Firestore { Firestore.firestore() }

    func getInventoriesBy(supplier: SupplierModel) async throws -> [POLineModel] {

        // 1) Try supplierId first
        let idSnapshot = try await db.collection("Inventories")
            .whereField("supplierId", isEqualTo: (supplier.id ?? ""))
            .getDocuments()

        if !idSnapshot.isEmpty {
            let inventoryList = try idSnapshot.documents.compactMap { doc in
                try doc.data(as: POLineModel.self)
            }
            return inventoryList
        }

        // 2) Fallback to supplierName if no id matches
        let nameSnapshot = try await db.collection("Inventories")
            .whereField("supplierName", isEqualTo: (supplier.name))
            .getDocuments()

        if !nameSnapshot.isEmpty {
            let inventoryList = try nameSnapshot.documents.compactMap { doc in
                try doc.data(as: POLineModel.self)
            }
            return inventoryList
        }

        // 3) Nothing found
        throw POServicesError.itemsNotFound
    }

    func saveDraft(orderDraft: POModel, lines: [POLineModel]) async throws {

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
        let linesRef = db.collection("purchaseOrders").document(poId)
            .collection(
                "lines")
        let batch = db.batch()

        // delete existing lines first (draft edit case)
        let existing = try await linesRef.getDocuments()
        for doc in existing.documents { batch.deleteDocument(doc.reference) }

        // add new lines
        for line in lines {
            let docRef = linesRef.document()
            var payload = line
            payload.id = docRef.documentID
            try batch.setData(from: payload, forDocument: docRef, merge: false)
        }

        try await batch.commit()

        // Update lineCount fields in PO doc
        let snapshot = try await linesRef.getDocuments()
        let count = snapshot.documents.count

        try await db.collection("purchaseOrders").document(poId).updateData([
            "lineCount": count,
            "updatedAt": FieldValue.serverTimestamp(),
        ])

    }

}

//MARK: - PO Details -
extension POServices {

    func fetchLines(poId: String) async throws -> [POLineModel] {
        let snap = try await db.collection("purchaseOrders").document(poId)
            .collection("lines").getDocuments()
        return try snap.documents.map { try $0.data(as: POLineModel.self) }
    }

    func deleteLine(poId: String, lineId: String) async throws {

        let poRef = db.collection("purchaseOrders").document(poId)
        let lineRef = poRef.collection("lines").document(lineId)

        let batch = db.batch()
        batch.deleteDocument(lineRef)
        batch.updateData(
            [
                "lineCount": FieldValue.increment(Int64(-1)),
                "updatedAt": FieldValue.serverTimestamp(),
            ], forDocument: poRef)
        try await batch.commit()

    }

    func updateOrderStatus(poId: String, status: POStatus) async throws {

        let poRef = db.collection("purchaseOrders").document(poId)
        let batch = db.batch()

        switch status {

        case .sent:
            batch.updateData(
                [
                    "status": status.rawValue,
                    "updatedAt": FieldValue.serverTimestamp(),
                    "sentAt": FieldValue.serverTimestamp(),
                ], forDocument: poRef)

        case .partial:
            break
        case .received:
            break
        case .closed, .canceled:
            batch.updateData(
                [
                    "status": status.rawValue,
                    "updatedAt": FieldValue.serverTimestamp(),
                ], forDocument: poRef)

        default:
            break
        }
        try await batch.commit()

    }

}

//MARK: - POView -
extension POServices {

    func fetchPurchaseOrderListOn(status: POStatus) async throws -> [POModel] {

        let snap = try await db.collection("purchaseOrders").getDocuments()

        let poList = try snap.documents.compactMap { doc in
            try doc.data(as: POModel.self)
        }

        return poList
    }

}
