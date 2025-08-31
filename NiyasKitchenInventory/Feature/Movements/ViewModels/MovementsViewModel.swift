//
//  MovementsViewModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 28/08/25.
//

import Foundation

@Observable final class MovementsViewModel {
    
    var showInventoryList:Bool = false
    var movementList:[MovementModel] = []
    
    private let service = MovementsServices()
    func getMovementList() async {
        
        do {
            self.movementList = try await service.fetchMovements()
        }catch {
            print(error)
        }
        
    }
}
