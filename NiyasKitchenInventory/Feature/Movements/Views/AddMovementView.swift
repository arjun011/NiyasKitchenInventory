//
//  AddMovementView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 28/08/25.
//

import SwiftUI

struct AddMovementView1: View {
    @Environment(AppSession.self) private var session
    var inventory: InventoryItemModel
    @State private var vm = AddMovementViewModel()
    var body: some View {

        Form {
            Section {
                HStack {

                    Label {
                        Text(inventory.name)
                    } icon: {
                        Image(systemName: "shippingbox.fill")
                            .foregroundStyle(Color.brandPrimary)
                    }

                    Spacer()
                    Text(
                        "Current: \(inventory.formattedQuantity) \(inventory.unit)"
                    )
                    .foregroundStyle(.secondary)
                }
            }

            Section {

                Picker("Types", selection: $vm.typesOfMovement) {

                    ForEach(MovementType.allCases) {
                        type in
                        Text(type.rawValue).tag(type)
                    }

                }.pickerStyle(.segmented)

            } header: {
                Text("Types")
            }

            Section {

                TextField("Enter Quantity", text: $vm.quantity)
                    .keyboardType(.decimalPad)

            } header: {
                Text("QUANTITY")
            }

            
            if vm.typesOfMovement == .in {
                
                Section {

                    Menu {
                        Picker("Supplier", selection: $vm.selectedSupplier) {
                            Text("Select supplier").tag(SupplierModel?.none)
                            ForEach(vm.suppliers) { sup in
                                Text(sup.name).tag(Optional(sup))
                            }
                        }
                    } label: {
                        Label(
                            "\(vm.selectedSupplier?.name ?? "Select Supplier")",
                            systemImage: "person.2.fill"
                        )
                        .foregroundStyle(
                            vm.selectedSupplier == nil
                                ? .secondary : Color.brandPrimary)
                    }

                } header: {
                    Text("SUPPLIER")
                }.task {
                     await vm.getSupplierList()
                     vm.selectedSupplier = vm.suppliers.first{
                        $0.id.uuidString == inventory.supplierId ?? ""
                    }
                    
                }
            }
            

            
            Section {
                TextField("Enter note", text: $vm.note, axis: .vertical)
                    .lineLimit(3, reservesSpace: true)
            } header: {
                Text("Note(Optional)")
            }


        }.navigationTitle("Add Movement")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            await vm.saveMovement(inventory: self.inventory, profile: session.profile)
                        }
                    } label: {
                        Text("Save")
                            .foregroundStyle(Color.brandPrimary)

                    }.disabled(!vm.isValidate)
                    .opacity(vm.isValidate ? 1 : 0.5)

                }
            }

    }
}

#Preview {
    
    NavigationStack {
        AddMovementView1(inventory: mockInventory.first!)
            .environment(AppSession())
    }
}
