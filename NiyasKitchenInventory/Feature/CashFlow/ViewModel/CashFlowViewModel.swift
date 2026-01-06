//
//  CashFlowViewModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 30/12/25.
//

import Foundation

@MainActor
@Observable final class CashFlowViewModel {

    var ammount: String = ""
    var description: String = ""
    var flowType: MovementType = .out
    var errorMessage: String = ""
    var isValidate: Bool {
        return !ammount.isEmpty && !description.isEmpty
    }

    private var services: CashServicesProtocol
    
    init(services: CashServicesProtocol = CashFlowServices()) {
        self.services = services
    }
    
    func saveCashFlow(by userName: String, dateSubmitted: Date) async {
        
        let cashFlow = CashFlowModel(ammount: Float(ammount) ?? 0, description: self.description, created: dateSubmitted, createdBy: userName, flowType: self.flowType.rawValue)
        
        do {
            try await self.services.saveCashFlow(flow: cashFlow)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}

