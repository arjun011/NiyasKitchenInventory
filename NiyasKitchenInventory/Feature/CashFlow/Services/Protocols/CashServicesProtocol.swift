//
//  CashServicesProtocol.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 30/12/25.
//

import Foundation
import Firebase
protocol CashServicesProtocol:Sendable {
    
    var db:Firestore {get}
    func saveCashFlow(flow: CashFlowModel) async throws
    
    func fetchCashFlows(startDate: Date, endDate: Date) async throws -> [CashFlowModel]
    
    func fetchDailySalesClosings(startDate: Date, endDate: Date) async throws -> [DailySalesClosingPoint]
    
    func fetchCashFlowsAndSalesClosings(startDate: Date, endDate: Date) async throws -> ([CashFlowModel], [DailySalesClosingPoint])
}
