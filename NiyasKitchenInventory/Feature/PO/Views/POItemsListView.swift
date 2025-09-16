//
//  POItemsListView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 02/09/25.
//

import SwiftUI

struct POItemsListView: View {

    @Environment(\.dismiss) private var dismiss
    @Binding var orderItemList: [POLineModel]
    @Binding var selections: Set<POLineModel.ID>

    @State private var showQtyAlert = false
    @State private var editingID: POLineModel.ID?
    @State private var qtyText = ""

    //var onDone:([POItemsModel]) -> Void
    var body: some View {

        VStack {

            List(orderItemList, selection: $selections) { item in
                
                VStack(alignment: .leading, content: {

                    HStack {

                        Text(item.itemName)
                        
                        if item.isLowStock {
                            Text("LOW STOCK")
                                .font(.caption2.weight(.regular))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.appDanger, in: Capsule())
                                .padding(.top, 4)
                        }
                        Spacer()
                        Text(
                            "\(item.orderedQty ?? 0, format: .number) \(item.unitName)"
                        )
                        .onTapGesture {
                            editingID = item.id
                            qtyText = String(item.orderedQty ?? 0)
                            showQtyAlert = true
                        }
                    }
                    
                    Text("stock: \(item.quantity, format: .number) \(item.unitName)")
                        .font(.subheadline.weight(.light))
                        .foregroundStyle(Color.secondary)
                    
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

    @Previewable @State var items = [POLineModel]()
    @Previewable @State var selection = Set<POLineModel.ID>()
    NavigationStack {
        POItemsListView(orderItemList: $items, selections: $selection)
    }

}
