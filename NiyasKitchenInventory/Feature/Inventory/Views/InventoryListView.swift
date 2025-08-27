//
//  InventoryListView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 17/08/25.
//

import SwiftUI

struct InventoryListView: View {

    @State private var vm = InventoryListViewModel()

    var body: some View {

        ZStack {

            VStack {

                // Filter bar

                FilterBarView(
                    suppliers: $vm.suppliers,
                    selectedSupplier: $vm.selectedSupplier,
                    showLowStockOnly: $vm.showLowStockOnly,
                    sortedByNewToOld: $vm.sortedByNewToOld,
                    showStaleOnly: $vm.showStaleOnly
                ).padding(.horizontal, 12)
                    .layoutPriority(1)
                    .task {
                        await vm.getSupplierList()
                    }

                // List of Items
                checkFilterItemsMatch()
                    .task {
                        await vm.getInventoryList()
                    }
            }.disabled(vm.isLoading)
                .blur(radius: vm.isLoading ? 1 : 0.3)
            if vm.isLoading {
                ProgressView()
                    .tint(Color.brandPrimary)
            }

        }

        .navigationTitle("Inventory")
        .navigationBarTitleDisplayMode(.automatic)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    AddEditInventoryView()
                } label: {
                    Image(systemName: "plus.circle.fill")
                }.tint(Color.brandPrimary)

            }
        }.searchable(
            text: $vm.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: Text("Search items by name")
        )
        .layoutPriority(2)

    }
}

extension InventoryListView {
    func checkFilterItemsMatch() -> AnyView {
        if vm.filteredItems.isEmpty {
            return AnyView(
                ContentUnavailableView {

                    Label(
                        "No items match",
                        systemImage: "text.page.badge.magnifyingglass")

                } description: {
                    Text("Try clearing filters or searching a different name.")
                })
        } else {
            return AnyView(
                List(vm.filteredItems) { item in
                    InventoryRowView(item: item)
                }.listStyle(.plain))
        }
    }

}

#Preview {

    NavigationStack {
        InventoryListView()
    }

}
