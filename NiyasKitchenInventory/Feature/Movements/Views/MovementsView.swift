//
//  MovementsView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 28/08/25.
//

import SwiftUI

struct MovementsView: View {
    
    private enum Route1: Hashable {
        case addMovement(item: InventoryItemModel)
    }

    @State private var vm = MovementsViewModel()
    @State private var navPath:[Route1] = []
    
    var body: some View {
       
        NavigationStack(path: $navPath) {
           
            VStack {
            
            }.sheet(isPresented: $vm.showInventoryList, content: {
                SelectItemListView { selectedInventory in
                    print(selectedInventory.name)
                    
                    navPath.append(.addMovement(item: selectedInventory))
                    
                }
            })
            .navigationTitle("Movements")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        vm.showInventoryList.toggle()
                    } label: {
                        Image(systemName: "plus.circle")
                            .tint(Color.brandPrimary)
                    }

                }
            }.navigationDestination(for: Route1.self) { screenEnum in
                
                MovementsView.navigate(to: screenEnum)
            }

        }
        
    }
}

extension MovementsView {
    
   private static func navigate(to screen: Route1) -> some View {
        
        switch screen {
        case let .addMovement(item: item):
            AddMovementView1(inventory: item)
        }
    }
}

#Preview {
    NavigationStack {
        MovementsView()
    }
    
}
