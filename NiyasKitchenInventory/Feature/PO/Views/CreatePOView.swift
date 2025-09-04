//
//  CreatePOView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 02/09/25.
//

import SwiftUI

struct CreatePOView: View {

    @State private var vm = CreatePOViewModel()
    var body: some View {

        ZStack {
            Form {
                Section {
                    Button {

                        if vm.supplierList.count > 0 {
                            vm.showSupplierList = true
                        }

                    } label: {

                        HStack(alignment: .center) {

                            Label(
                                vm.supplierName.isEmpty
                                    ? "Select Supplier" : vm.supplierName,
                                systemImage: "person.2.fill")

                            Spacer()

                            Image(systemName: "chevron.down")
                        }.tint(Color.brandPrimary)

                    }

                    TextField("Email", text: $vm.email).keyboardType(
                        .emailAddress
                    )
                    .textInputAutocapitalization(.never)

                    TextField("Contact (Optional)", text: $vm.contact)
                        .keyboardType(.phonePad)
                        .textInputAutocapitalization(.never)

                } header: {
                    Text("SUPPLIER")
                }

                Section {
                    DatePicker(
                        "Delivery Date", selection: $vm.expectedDeliveryDate,
                        displayedComponents: .date
                    )
                    .tint(Color.brandPrimary)
                } header: {
                    Text("EXPECTED DATE")
                }

                Section {

                    ForEach(vm.orderItemList) { item in

                        LabeledContent {

                            Group {
                                Text(item.orderedQty, format: .number)
                                    + Text(" \(item.unitName)")
                            }
                        } label: {
                            Text(item.itemName)
                        }
                    }

                    NavigationLink {

                        POItemsListView(orderItemList: $vm.supplierItemsList, selections: $vm.selections)
                       
                    } label: {
                        Label("Add Item", systemImage: "text.badge.plus")
                            .listItemTint(Color.brandPrimary)
                            .foregroundStyle(Color.brandPrimary)
                    }.disabled(vm.selectedSupplierID == nil)

                } header: {
                    Text("Items")
                }

                Section {
                    TextField(
                        "Delivery Instruction, Contact, etc..", text: $vm.note,
                        axis: .vertical
                    )
                    .lineLimit(3, reservesSpace: true)
                } header: {
                    Text("Note (Optional)")
                }

            }.sheet(
                isPresented: $vm.showSupplierList,
                content: {
                    SupplierListView(supplierList: vm.supplierList) {
                        selectedSupplier in

                        vm.selectedSupplier = selectedSupplier
                    }
                }
            )
            .navigationTitle("New Purchase Order")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {

                    } label: {
                        Text("Save Draft")
                            .foregroundStyle(Color.brandPrimary)
                    }

                }
            }
        }.task {
            await vm.fetchSupplierList()
        }

    }
}

#Preview {

    NavigationStack {
        CreatePOView()
    }

}
