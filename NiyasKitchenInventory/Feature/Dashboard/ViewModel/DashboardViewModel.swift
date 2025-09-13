//
//  DashboardViewModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 31/08/25.
//

import Foundation
@MainActor @Observable final class DashboardViewModel {
    
    var totalInventoryCount:Int = 0
    var lowStockInventoryCount:Int = 0
    var staleInventoryCount:Int = 0
    var wasteLastSevenDayCount:Int = 0
    
    
    private let inventoryServices = InventoryListServices()
    private let movementServices = MovementsServices()
    
    func getInventoryList() async {
        
        do {
            
            let inventoryList = try await inventoryServices.fetchInventory()
            self.updateDashBoard(inventoryList: inventoryList)
        }catch {
            print(error.localizedDescription)
        }
        
    }
    
    private func updateDashBoard(inventoryList: [InventoryItemModel]) {
        
        self.totalInventoryCount = inventoryList.count
        self.lowStockInventoryCount = inventoryList.filter{ $0.isLowStock}.count
        
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        self.staleInventoryCount = inventoryList.filter { $0.updatedAt < sevenDaysAgo }.count
        
    }
    
    func getWasteCount() async {
        
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        do {
            
            let wastCount = try await movementServices.countWastMovementsSince(sevenDaysAgo)
            print("Waste Count = \(wastCount)")
            self.wasteLastSevenDayCount = wastCount
            
        }catch {
            print("Waste error")
            print(error.localizedDescription)
        }
    }
}
