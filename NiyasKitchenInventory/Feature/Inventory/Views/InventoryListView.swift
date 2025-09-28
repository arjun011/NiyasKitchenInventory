//
//  InventoryListView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 17/08/25.
//

import SwiftUI

struct InventoryListView: View {

    @State private var vm = InventoryListViewModel()
    @State private var showEditView: Bool = false
    @State var selectedInventory: InventoryItemModel? = nil
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
                .opacity(vm.isLoading ? 0.5 : 1)
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
     func checkFilterItemsMatch() -> some View {

        Group {
            if vm.filteredItems.isEmpty {
                ContentUnavailableView {
                    Label(
                        "No items match",
                        systemImage: "text.page.badge.magnifyingglass")

                } description: {
                    Text("Try clearing filters or searching a different name.")
                }
            } else {

                List(vm.filteredItems) { item in

                    InventoryRowView(item: item).swipeActions {
                        Button {
                            
                            Task {
                                await vm.removedInventoryItem(at: item.id ?? "")
                            }
                        } label: {
                            Image(systemName: "trash")
                                .tint(Color.red)
                        }

                        Button {
                            selectedInventory = item
                            showEditView = true
                        } label: {
                            Image(systemName: "pencil")
                                .tint(Color.green)
                        }
                    }

                }.listStyle(.plain)
            }
        }.navigationDestination(isPresented: $showEditView) {
            if let item = selectedInventory {
                AddEditInventoryView(isEdit: true, selectedItemToEdit: item)
            }
        }

    }

}

#Preview {

    NavigationStack {
        InventoryListView()
    }

}
