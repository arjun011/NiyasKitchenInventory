//
//  DashboardServices.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 16/09/25.
//

import Foundation
//import Firebase
//import FirebaseCore
import FirebaseFirestore
struct DashboardServices: Sendable {
    
    private var db:Firestore { Firestore.firestore() }
    
    func getPunches(userId: String, date: Date) async throws -> [PunchModel] {
        let dateString = formatDate(date)
        let punchesRef = db.collection("users")
            .document(userId)
            .collection("attendance")
            .document(dateString)
            .collection("punches")

        let snapshot = try await punchesRef
            .order(by: "timestamp")
            .getDocuments()

        return snapshot.documents.compactMap {
            try? $0.data(as: PunchModel.self)
        }
    }

    func addPunch(userId: String, timestamp: Date, type: PunchType, isAutoOut: Bool = false, isIrregular: Bool = false) async throws {
        let dateString = formatDate(timestamp)
        let punchesRef = db.collection("users")
            .document(userId)
            .collection("attendance")
            .document(dateString)
            .collection("punches")

        let newPunch = PunchModel(
            id: nil,
            timestamp: timestamp,
            type: type,
            isAutoOut: isAutoOut,
            isIrregular: isIrregular
        )

        _ = try punchesRef.addDocument(from: newPunch)
    }

    nonisolated private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
