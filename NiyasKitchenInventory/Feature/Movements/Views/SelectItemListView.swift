//
//  SelectItemListView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 27/08/25.
//

import SwiftUI

struct SelectItemListView: View {
    
    @Environment(\.dismiss) var dismiss
    private let service:InventoryListServices = InventoryListServices()
    @State var searchByName: String = ""
    @State var inventoryItems: [InventoryItemModel] = []
    var selectedRow: (InventoryItemModel) -> Void
    
    var filteredList: [InventoryItemModel] {

        var filteredByName = inventoryItems

        // Search by name/SKU
        let q = searchByName.trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        if !q.isEmpty {
            filteredByName = filteredByName.filter {
                $0.name.lowercased().contains(q)
            }
        }
        return filteredByName
    }

    var body: some View {

        NavigationStack {

            VStack {

                List(self.filteredList) { item in

                    HStack {

                        VStack(
                            alignment: .leading,
                            content: {

                                Text("\(item.name)")
                                    .fontWeight(.semibold)
                                Text(
                                    "current : \(item.formattedQuantity) \(item.unit)"
                                )
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                            })
                        Spacer()
                    }.contentShape(Rectangle())
                        .onTapGesture {
                            selectedRow(item)
                            dismiss()
                        }
                }

            }.searchable(text: $searchByName)
                .task {
                    do {
                        self.inventoryItems = try await service.fetchInventory()
                    } catch {
                        print("Error =\(error)")
                    }
                }
        }
    }
}

#Preview {

    SelectItemListView { selectedItem in
        print(selectedItem)
    }

}
