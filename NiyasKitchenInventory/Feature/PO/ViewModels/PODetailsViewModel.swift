//
//  PODetailsViewModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 08/09/25.
//

import Foundation

@MainActor @Observable final class PODetailsViewModel {

    var lines: [POLineModel] = []
    private let services = POServices()

    
    func getPOLines(poID:String) async {
        
        do {
            self.lines = try await services.fetchLines(poId: poID)
            print(self.lines.count)
        }catch {
            print(error)
        }
        
    }
    
    func deletedLine(poID:String, lineId:String) async {
        do {
            try await services.deleteLine(poId: poID, lineId: lineId)
            print("deleted line")
            
            if let index = self.lines.firstIndex(where: { $0.id == lineId}) {
                self.lines.remove(at: index)
            }
            
            
        }catch {
            print(error)
        }
    }
    
    func cancelOrder(poID:String) async {
        
        do{
            try await services.updateOrderStatus(poId: poID, status: .canceled)
            print("Order canceled")
        }catch {
            print(error)
        }
        
    }
    
    
}
