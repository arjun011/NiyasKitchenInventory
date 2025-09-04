//
//  POItemsListView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 02/09/25.
//

import SwiftUI

struct POItemsListView: View {

    @Environment(\.dismiss) private var dismiss
    @Binding var orderItemList: [POItemsModel]
    @Binding var selections: Set<POItemsModel.ID>

    @State private var showQtyAlert = false
    @State private var editingID: POItemsModel.ID?
    @State private var qtyText = ""

    //var onDone:([POItemsModel]) -> Void
    var body: some View {

        VStack {

            List(orderItemList, selection: $selections) { item in

                HStack(
                    alignment: .center,
                    content: {
                        Text(item.itemName)
                        Spacer()

                        Group {
                            Text(item.orderedQty, format: .number)
                                + Text(" \(item.unitName)")
                        }.onTapGesture {
                            editingID = item.id
                            qtyText = String(item.orderedQty)
                            showQtyAlert = true

                        }
                    })
            }

        }.alert(
            "Enter Quantity", isPresented: $showQtyAlert,
            actions: {

                TextField("Quanity", text: $qtyText)
                    .keyboardType(.decimalPad)

                Button(
                    "Cancel", role: .cancel,
                    action: {
                        showQtyAlert.toggle()
                        qtyText = ""
                    })

                Button(
                    "Update",
                    action: {

                        applyQuantityChange()

                    }
                ).disabled(!isValidQty)
            }
        )

        .navigationTitle("Add Items")
        .navigationBarTitleDisplayMode(.automatic)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    dismiss()
                }
            }
        }
        .environment(\.editMode, .constant(.active))

    }

    private var isValidQty: Bool {
        let v = Double(qtyText.replacingOccurrences(of: ",", with: ".")) ?? 0
        return v > 0
    }

    private func applyQuantityChange() {
        guard let id = editingID else { return }
        let v = Double(qtyText.replacingOccurrences(of: ",", with: ".")) ?? 0
        if let idx = orderItemList.firstIndex(where: { $0.id == id }) {
            orderItemList[idx].orderedQty = v
        }
        showQtyAlert = false
        editingID = nil
        qtyText = ""
    }
}

#Preview {

    @Previewable @State var items = [POItemsModel]()
    @Previewable @State var selection = Set<POItemsModel.ID>()
    NavigationStack {
        POItemsListView(orderItemList: $items, selections: $selection)
    }

}
