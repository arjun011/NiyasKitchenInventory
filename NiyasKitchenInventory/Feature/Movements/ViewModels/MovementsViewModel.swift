//
//  MovementsViewModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 28/08/25.
//

import Foundation

@MainActor @Observable final class MovementsViewModel {
    
    var showInventoryList:Bool = false
    var movementList:[MovementModel] = []
    nonisolated private let service = MovementsServices()
    var filteredType:MovementType = .all
    var range: RangeFilter = .today
    
    var isLoading:Bool = false
    
    var filteredMovementList:[MovementModel] {
        
        movementList.filter {matchesRange($0.createdAt)}
                    .filter { filteredType == .all ? true : $0.mType == filteredType }
                    .sorted { $0.createdAt > $1.createdAt }
        
        
    }
    
    func getMovementList() async {
        
        self.isLoading = true
        defer {
            self.isLoading = false
        }
        do {
            self.movementList = try await service.fetchMovements()
        }catch {
            print(error)
        }
        
    }
    
    private func matchesRange(_ date: Date) -> Bool {
        switch range {
        case .today: return Calendar.current.isDateInToday(date)
        case .d7:    return date >= Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        case .d30:   return date >= Calendar.current.date(byAdding: .day, value: -30, to: Date())!
        case .all:   return true
        }
    }
    
    
}
