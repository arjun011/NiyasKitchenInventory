//
//  DashboardView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 12/08/25.
//

import SwiftUI

struct DashboardView: View {
    
    @Environment(AppSession.self) private var session
    @State private var vm = DashboardViewModel()
    
    var body: some View {
        
        ScrollView {
         
            VStack(alignment: .leading, spacing: 16) {
                KIPStatCardView(title: "Total Items", value: vm.totalInventoryCount, icon: "cube.box.fill", bgColor: Color.brandPrimary)
                
                KIPStatCardView(title: "Low Stock", value: vm.lowStockInventoryCount, icon: "exclamationmark.triangle.fill", bgColor: Color.appWarning)
                
                KIPStatCardView(title: "Needs Review (7d)", value: vm.staleInventoryCount, icon: "clock.fill", bgColor: Color.brandPrimary)
                
                KIPStatCardView1(title: "Waste This Week", value: vm.wasteLastSevenDayCount, icon: "trash.fill", bgColor: Color.appDanger)
                
                VStack(alignment: .leading, content: {
                   
                    Text("Quick Actions")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(Color.textPrimary)
                    
                    HStack(alignment: .center, spacing: 15) {
                        PillButtonView(title: "StockIn")
                        PillButtonView(title: "StockOut")
                    }
                    
                    HStack(alignment: .center, spacing: 15) {
                        PillButtonView(title: "Punch In")
                        PillButtonView(title: "Punch Out")
                    }
                    
                    
                }).padding(.horizontal)
            }
            
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    
                    Text("Hi, \(self.session.profile?.displayName ?? "Patel")")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.textPrimary)
                    
                }
            }
            
        }.task {
            await withTaskGroup(of: Void.self) { group in
                   group.addTask { await vm.getInventoryList() }
                   group.addTask { await vm.getWasteCount() }
               }
        }
    }
}

#Preview {
    
    NavigationStack {
        DashboardView()
            .environment(AppSession())
    }
    
    
}
