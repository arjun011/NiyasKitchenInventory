//
//  TabShellView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 15/08/25.
//

import SwiftUI

struct TabShellView: View {

    enum TabSection: Hashable {
        case dashbaord, inventory, movements, reports, settings
    }

    @State var selectedTab: TabSection = .dashbaord

    var body: some View {

        TabView(selection: $selectedTab) {

            Tab("Dashboard", systemImage: "house.fill", value: .dashbaord) {
                
                NavigationStack {
                    DashboardView()
                }
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
                Text("Movements")
            }

            Tab("Reports", systemImage: "chart.bar.fill", value: .reports) {
                Text("Reports")
            }

            Tab("Settings", systemImage: "gearshape.fill", value: .settings) {
                Text("Reports")
            }

        }.tint(Color.brandPrimary)
            .toolbarBackground(Color.appBackground, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)

    }
}

#Preview {
    TabShellView()
}
