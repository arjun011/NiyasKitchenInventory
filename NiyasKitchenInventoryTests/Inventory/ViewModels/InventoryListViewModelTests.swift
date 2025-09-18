//
//  InventoryListViewModelTests.swift
//  NiyasKitchenInventoryTests
//
//  Created by Arjun on 17/09/25.
//

import Testing
@testable import NiyasKitchenInventory
import Foundation

@Suite struct InventoryListViewModelTests {

    @Test func testSearchTextFilterItems() async {
     
        var moc = MocInventoryListServices()
        moc.mockItems = [.mock(name: "Tometo"),
                         .mock(name: "Potato"),
                         .mock(name: "Paneer")]
        
        
        let vm = await InventoryListViewModel(services: moc)
        await vm.getInventoryList()
        
        await MainActor.run {
            vm.searchText = "to"
        }
        
        let filtered = await MainActor.run { vm.filteredItems }
        #expect(filtered.count == 2)
        
    }
    
    @Test func testLowStockOnlyFilterItems() async {
        
        var moc = MocInventoryListServices()
        moc.mockItems = [.mock(quantity: 10, lowStockThreshold: 5),
                         .mock(quantity: 5, lowStockThreshold: 10),
                         .mock(quantity: 30, lowStockThreshold: 15)]
     
        let vm = await InventoryListViewModel(services: moc)
        await vm.getInventoryList()
        
        await MainActor.run {
            vm.showLowStockOnly = true
            #expect(vm.filteredItems.count == 1)
        }
        
        
    }

    @Test func testStaleOnlyFilterItems() async {
        
        let dateOfLastWeek = Calendar.current.date(byAdding: .day, value: -8, to: Date())
        var moc = MocInventoryListServices()
        moc.mockItems = [.mock(updatedAt: dateOfLastWeek!),
                         .mock(updatedAt: Date())]
        
        let vm = await InventoryListViewModel(services: moc)
        
        await vm.getInventoryList()
        
        await MainActor.run {
            vm.showStaleOnly = true
            #expect(vm.filteredItems.count == 1)
        }
        
    }
    
    @Test func testFetchSupplierList() async {
        
        var moc = MockAddEditInventoryServices()
        moc.suppliers = [.mock(name: "Giro"),
                         .mock(name: "Birmingham Vegetable market")]
        
        let vm = await InventoryListViewModel(supplierServies: moc)
        await vm.getSupplierList()
        
        await MainActor.run {
            #expect(vm.suppliers == ["Giro","Birmingham Vegetable market"])
        }
        
    }
}
