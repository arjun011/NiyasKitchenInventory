//
//  CashFlowReportViewModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 01/01/26.
//

import Foundation

@MainActor
@Observable final class CashFlowReportViewModel {

    var startDate =
        Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
    var endDate = Date()
    var showDatePicker: Bool = false
    var cashFlowReport = [CashFlowModel]()
    
    var dailySalesClosings = [DailySalesClosingPoint]()

    private let services: CashServicesProtocol
    
    var remaningCash:Double {
        get {
            let inTotal:Double = cashFlowReport.filter{$0.flowType == MovementType.in.rawValue}.map{Double($0.ammount)}.reduce(0.0, +)

            let dailySalesCash:Double = dailySalesClosings.map{$0.cash}.reduce(0.0, +)
            
            let outTotal: Double = cashFlowReport.filter{$0.flowType == MovementType.out.rawValue}.map{Double($0.ammount)}.reduce(0.0, +)
            
            return ((inTotal + dailySalesCash) - outTotal)
        }
    }

    init(services: CashServicesProtocol = CashFlowServices()) {
        self.services = services
    }

    func loadReport() async {

        do {
            
           let (flowReport,dailySales) = try await services.fetchCashFlowsAndSalesClosings(startDate: startDate, endDate: endDate)
            
            self.cashFlowReport = flowReport
            self.dailySalesClosings = dailySales
            print(cashFlowReport.count)
            print(dailySalesClosings.count)

        } catch {
            print(error.localizedDescription)
        }

    }
}

