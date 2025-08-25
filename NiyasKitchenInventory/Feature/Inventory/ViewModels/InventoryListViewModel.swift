//
//  InventoryListViewModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 17/08/25.
//

import Foundation

@Observable class InventoryListViewModel {
    
    var inventoryItems:[InventoryItemModel] = mockInventory
    var searchText:String = ""
    
    var suppliers = Array(
        Set(
            mockInventory.map({
                $0.supplierName
            })))

     var selectedSupplier: (String?, Bool) = (nil, false)
     var showLowStockOnly: Bool = false
     var sortedByNewToOld: Bool = false
     var showStaleOnly: Bool = false
    
    
    var filteredItems: [InventoryItemModel] {
        var filteredByName = inventoryItems

        // Search by name/SKU
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if !q.isEmpty {
            filteredByName = filteredByName.filter {
                $0.name.lowercased().contains(q)
            }
        }
        
        if selectedSupplier.1 == true {
            filteredByName = filteredByName.filter{
                $0.supplierName.contains(selectedSupplier.0 ?? "")
            }
        }
        
        if showLowStockOnly {
            filteredByName =  filteredByName.filter{ $0.isLowStock }
        }
        
        if showStaleOnly {
            filteredByName = filteredByName.filter{ $0.isStale }
        }
        
        if sortedByNewToOld {
            filteredByName.sort { $0.updatedAt > $1.updatedAt }
        }
        
        
        
        return filteredByName
    }
    
  
}
