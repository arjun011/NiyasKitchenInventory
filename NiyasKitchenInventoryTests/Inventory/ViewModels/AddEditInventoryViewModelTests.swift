//
//  AddEditInventoryViewModelTests.swift
//  NiyasKitchenInventoryTests
//
//  Created by Arjun on 19/09/25.
//

import Testing
@testable import NiyasKitchenInventory
import Foundation

@Suite struct AddEditInventoryViewModelTests {

    @Test func testGetUnits() async {
        
        var mock = MockAddEditInventoryServices()
        mock.units = [.mock(name: "KG"),
                      .mock(name: "L"),
                      .mock(name: "Box")]
        
        let vm = await AddEditInventoryViewModel(service: mock)
        await vm.getUnits()
        
        await MainActor.run {
            
            #expect(vm.units == mock.units)
            #expect(vm.selectedUnit == mock.units.first)
            
        }
        
    }
    
    @Test func testSaveInventory() async {
        
        var mock = MockAddEditInventoryServices()
        mock.inventoryItems = .mock(name: "Panner", quantity: 20, unit: "KG", supplierName: "Giro", lowStockThreshold: 12, updatedAt: Date())
       
        let vm = await AddEditInventoryViewModel(service: mock)
        
        await vm.saveInventory()
        
        await MainActor.run {
            #expect(vm.errorMessage == "Item added successfully")
            #expect(vm.name == "")
        }
        
    }
    
    @Test func testGetCategoryList() async {
        
        var mock = MockAddEditInventoryServices()
        mock.inventoeryCategory = [.mock(name: "Vegetables"),
                                   .mock(name: "Packaging"),
                                   .mock(name: "Bar")]
        let vm = await AddEditInventoryViewModel()
        await vm.getCategoryList()
        
        await MainActor.run {
            #expect(vm.categories == mock.inventoeryCategory)
        }
        
    }

}
