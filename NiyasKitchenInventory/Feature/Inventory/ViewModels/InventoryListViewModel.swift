//
//  InventoryListViewModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 17/08/25.
//

import Foundation

@MainActor @Observable class InventoryListViewModel {

    private let services: InventoryListServiceProtocol
    private let supplierServies: AddEditInventoryServicesProtocol
    
    init(services: InventoryListServiceProtocol = InventoryListServices(), supplierServies:AddEditInventoryServicesProtocol = AddEditInventoryServices() ) {
        self.services = services
        self.supplierServies = supplierServies
    }
    
    
    var isLoading:Bool = false
    var inventoryItems: [InventoryItemModel] = []
    var searchText: String = ""

    var suppliers:[String] = []

    var selectedSupplier: (String?, Bool) = (nil, false)
    var showLowStockOnly: Bool = false
    var sortedByNewToOld: Bool = false
    var showStaleOnly: Bool = false

    var filteredItems: [InventoryItemModel] {
        var filteredByName = inventoryItems

        // Search by name/SKU
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        if !q.isEmpty {
            filteredByName = filteredByName.filter {
                $0.name.lowercased().contains(q)
            }
        }

        if selectedSupplier.1 == true {
            filteredByName = filteredByName.filter {
                $0.supplierName.contains(selectedSupplier.0 ?? "")
            }
        }

        if showLowStockOnly {
            filteredByName = filteredByName.filter { $0.isLowStock }
        }

        if showStaleOnly {
            filteredByName = filteredByName.filter { $0.isStale }
        }

        if sortedByNewToOld {
            filteredByName.sort { $0.updatedAt > $1.updatedAt }
        }

        return filteredByName
    }

    func getInventoryList() async {

        defer {
            isLoading = false
        }
        
        isLoading = true
        
        do {
            self.inventoryItems = try await services.fetchInventory()
        } catch {
            print("Error =\(error)")
        }
    }
    
    func getSupplierList() async {
        
        defer {
            isLoading = false
        }
        
        isLoading = true

        do {
            self.suppliers = try await self.supplierServies.fetchSupplierList().compactMap { return $0.name }
        }catch {
            print("Error =\(error)")
        }
        
    }
    
    func removedInventoryItem(at id: String) async {
        defer {
            isLoading = false
        }
        
        isLoading = true
        do {
            try await self.services.removedInventory(id: id)
            self.inventoryItems.removeAll(where: { $0.id == id })
        }catch {
            print("Error =\(error)")
        }
    }
    
    deinit {
        print("Deinit Inventory List")
    }
}
