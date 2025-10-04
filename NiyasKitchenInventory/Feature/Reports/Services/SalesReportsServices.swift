//
//  SalesReportsServices.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 02/10/25.
//

import Firebase
import Foundation

struct SalesReportsServices: Sendable {

    private var db: Firestore { Firestore.firestore() }

    func fetchDailySalesReports() async throws -> [DailySalesClosingPoint] {

        let snapshot = try await db.collection("sales").getDocuments()

        return try snapshot.documents.compactMap { doc in
            let salesPoint = try doc.data(as: DailySalesPoint.self)
            return salesPoint.closing
        }
    }

}
