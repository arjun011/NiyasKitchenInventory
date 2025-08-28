//
//  MovementsView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 28/08/25.
//

import SwiftUI

struct MovementsView: View {
    
    @State private var vm = MovementsViewModel()
    
    var body: some View {
       
        VStack {
        
        }.sheet(isPresented: $vm.showInventoryList, content: {
            SelectItemListView { selectedInventory in
                print(selectedInventory.name)
                
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
        }
        
    }
}

#Preview {
    NavigationStack {
        MovementsView()
    }
    
}
