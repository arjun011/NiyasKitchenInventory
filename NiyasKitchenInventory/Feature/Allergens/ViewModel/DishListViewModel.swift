//
//  DishListViewModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 12/02/26.
//

import Foundation
@MainActor
@Observable final class DishListViewModel {
    
    var dishList:[AllergensModel] = []
    private var services:AllergenceDishProtocol
    var searchText:String = ""
    var filteredDishes: [AllergensModel] {
        var filteredByName = dishList
        
        // Search by name/SKU
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        if !q.isEmpty {
            filteredByName = filteredByName.filter {
                $0.dishName.lowercased().contains(q)
            }
        }
        
        return filteredByName
    }
    
    init(services: AllergenceDishProtocol = AllergensDishServices()) {
        self.services = services
    }
    
    func getDishList() async  {
        
        do {
            self.dishList =  try await services.getDishList()
            print("DishList Count = \(self.dishList.count)")
        }catch {
            print("Dish not found")
            print(error.localizedDescription)
            
            
        }
        
    }
}

