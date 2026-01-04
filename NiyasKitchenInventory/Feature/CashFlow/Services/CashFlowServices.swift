//
//  CashFlowServices.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 30/12/25.
//

import Foundation
import Firebase

struct CashFlowServices: CashServicesProtocol {
    
    var db: Firestore {
        get {
            Firestore.firestore()
        }
    }
    
    private enum CashFlowError: Error {
        case manualTest
    }
    
    func saveCashFlow(flow: CashFlowModel) async throws {
       
        let doc = db.collection("cashFlow").document()
        var draft = flow
        draft.id = doc.documentID
        try doc.setData(from: draft, merge: false)
    }
    
    
    func fetchCashFlowsAndSalesClosings(startDate: Date, endDate: Date) async throws -> ([CashFlowModel], [DailySalesClosingPoint]) {
        
        let calendar = Calendar.current
        
        let startOfDay = calendar.startOfDay(for: startDate)

        // Compute the day after endDate’s day to make the upper bound exclusive
        guard let endOfDayExclusive = calendar.date(byAdding: Calendar.Component.day, value: 1, to: calendar.startOfDay(for: endDate)) else {
            return ([],[])
        }
        
        async let cashFlows = fetchCashFlows(startDate: startOfDay, endDate: endOfDayExclusive)
        async let sellingCash = fetchDailySalesClosings(startDate: startOfDay, endDate: endOfDayExclusive)
        return (try await cashFlows, try await sellingCash)
    }
    
    func fetchCashFlows(startDate: Date, endDate: Date) async throws -> [CashFlowModel] {
        
        
        let snapshot = try await db.collection("cashFlow")
            .whereField("created", isGreaterThanOrEqualTo: Timestamp(date: startDate))
                .whereField("created", isLessThan: Timestamp(date: endDate))
                .order(by: "created", descending: false)
            .getDocuments()

        let cashReport = try snapshot.documents.compactMap {
            try $0.data(as: CashFlowModel.self)
        }
        
        return cashReport
       
    }
    
    
    func fetchDailySalesClosings(startDate: Date, endDate: Date) async throws -> [DailySalesClosingPoint] {


        let snapshot = try await db.collection("sales").whereField("closing.timestamp", isGreaterThanOrEqualTo: Timestamp(date: startDate))
            .whereField("closing.timestamp", isLessThan: Timestamp(date: endDate))
            .order(by: "closing.timestamp", descending: false)
        .getDocuments()

        return try snapshot.documents.compactMap { doc in
            let salesPoint = try doc.data(as: DailySalesPoint.self)
            return salesPoint.closing
        }
    }
}

