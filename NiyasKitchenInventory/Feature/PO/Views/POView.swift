//
//  POView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 07/09/25.
//

import SwiftUI

struct POView: View {
    
    @State var vm = POViewModel()
    
    var body: some View {
    
        ZStack {
            VStack {
                List(vm.poList) { po in
                    
                    NavigationLink {
                        PODetailsView(orderDetail: po)
                    } label: {
                        PORowView(po: po)
                    }
                }
            }
        }.task {
            await vm.getPurachaseOrderOn(status: .all)
        }.navigationTitle("Purchase Orders")
        .navigationBarTitleDisplayMode(.automatic)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                
                NavigationLink {
                    CreatePOView()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .tint(Color.brandPrimary)
                }
            }
        }
    }
}

#Preview {
    
    NavigationStack {
        POView()
    }
    
}
