//
//  TabShellView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 15/08/25.
//

import SwiftUI

struct TabShellView: View {

    @Environment(AppSession.self) var session
    
    enum TabSection: Hashable {
        case dashbaord, inventory, movements, reports, settings
    }

    @State var selectedTab: TabSection = .dashbaord

    var body: some View {

        TabView(selection: $selectedTab) {

            Tab("Dashboard", systemImage: "house.fill", value: .dashbaord) {
                
                DashboardView()
                
            }

            Tab("Inventory", systemImage: "shippingbox.fill", value: .inventory) {
                NavigationStack {
                    InventoryListView()
                }
            }

            Tab(
                "Movements", systemImage: "arrow.left.arrow.right",
                value: .movements
            ) {
                
                    MovementsView()
                
            }
           
            Tab("Reports", systemImage: "chart.bar.fill", value: .reports) {
                
                Text("Comming soon..")
//                NavigationStack {
//                    POView()
//                }
                
                
            }

            Tab("Settings", systemImage: "gearshape.fill", value: .settings) {
               
                
                NavigationStack {
                    SettingsView()
                }
                
                
//                VStack {
//                  
//                    Text("Sign out")
//                    
//                }.task {
//                    await session.signOut()
//                }
                
            }

        }.tint(Color.brandPrimary)
            .toolbarBackground(Color.appBackground, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)

    }
}

#Preview {
    TabShellView()
}
