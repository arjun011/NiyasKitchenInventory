//
//  AddEditInventoryView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 20/08/25.
//

import SwiftUI

struct AddEditInventoryView: View {

    @State private var vm = AddEditInventoryViewModel()

    var body: some View {

        ZStack {

            VStack {
                Form {
                    Section {
                        TextField("Name", text: $vm.name)
                        TextField("SKU", text: $vm.sku)

                        HStack(
                            spacing: 5,
                            content: {

                                TextField(
                                    "Quantity", value: $vm.quantity,
                                    format: .number
                                )
                                .keyboardType(.decimalPad)

                                Picker("Unit", selection: $vm.selectedUnit) {
                                    ForEach(vm.units) { unit in
                                        Text(unit.name).tag(Optional(unit))
                                    }
                                }.tint(Color.brandPrimary)

                            })

                        TextField(
                            "Low stock threshold", value: $vm.lowStockThreshold,
                            format: .number
                        )
                        .keyboardType(.decimalPad)
                        .foregroundStyle(Color.appWarning)

                    } header: {
                        Text("Basic")
                    }

                    //Category

                    Section {
                        Menu {
                            Picker("Category", selection: $vm.selectedCategory)
                            {
                                Text("Select Category").tag(
                                    InventoryCategoryModel?.none)
                                ForEach(vm.categories) { cat in
                                    Text(cat.name).tag(Optional(cat))
                                }
                            }
                        } label: {
                            HStack {
                                Image(systemName: "tag.fill")
                                    .foregroundStyle(Color("BrandPrimary"))
                                Text(
                                    vm.selectedCategory?.name
                                        ?? "Choose Category"
                                )
                                .foregroundStyle(
                                    vm.selectedCategory == nil
                                        ? .secondary : Color.brandPrimary)
                                Spacer()
                                Image(systemName: "chevron.down").font(
                                    .footnote
                                )
                                .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }

                        Button {
                            vm.showAddCategory = true
                        } label: {
                            Label(
                                "Add Category", systemImage: "plus.circle.fill")
                        }
                    } header: {
                        Text("Category")
                    }

                    // SUPPLIER
                    Section {
                        Menu {
                            Picker("Supplier", selection: $vm.selectedSupplier)
                            {
                                Text("Select supplier").tag(SupplierModel?.none)
                                ForEach(vm.suppliers) { sup in
                                    Text(sup.name).tag(Optional(sup))
                                }
                            }
                        } label: {
                            HStack {
                                Image(systemName: "person.2.fill")
                                    .foregroundStyle(Color("BrandPrimary"))
                                Text(
                                    vm.selectedSupplier?.name
                                        ?? "Choose supplier"
                                )
                                .foregroundStyle(
                                    vm.selectedSupplier == nil
                                        ? .secondary : Color.brandPrimary)
                                Spacer()
                                Image(systemName: "chevron.down").font(
                                    .footnote
                                )
                                .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }

                        Button {
                            vm.showAddSupplier = true
                        } label: {
                            Label(
                                "Add Supplier", systemImage: "plus.circle.fill")
                        }
                    } header: {
                        Text("Supplier")
                    }

                    // NOTES
                    Section("Notes (optional)") {
                        TextField(
                            "Notes about item (brand, packaging, etc.)",
                            text: $vm.note, axis: .vertical
                        )
                        .lineLimit(3, reservesSpace: true)
                    }

                }.foregroundStyle(Color.brandPrimary)
                    .task {
                        guard !vm.isLoading else { return }
                        vm.isLoading = true

                        await withTaskGroup(of: Void.self) { group in
                            group.addTask { await vm.getUnits() }
                            group.addTask { await vm.getSupplierList() }
                            group.addTask { await vm.getCategoryList() }

                            await group.waitForAll()

                        }
                        vm.isLoading = false
                    }
            }.disabled(vm.isLoading)
                .blur(radius: vm.isLoading ? 1 : 0)

            if vm.isLoading {
                ProgressView()
                    .tint(Color.brandPrimary)
            }

        }.sheet(
            isPresented: $vm.showAddSupplier,
            content: {
                AddSupplierView { newSupplier in
                    Task {
                        await vm.saveSupplier(supplier: newSupplier)
                    }

                }
            }
        ).alert(
            "Categoery", isPresented: $vm.showAddCategory,
            actions: {
                TextField("Name", text: $vm.categoryName)

                Button(
                    "Cancel", role: .cancel,
                    action: {
                        vm.showAddCategory.toggle()
                    })

                Button(
                    "Save",
                    action: {

                        guard
                            !vm.categoryName.trimmingCharacters(
                                in: .whitespacesAndNewlines
                            ).isEmpty
                        else {
                            return
                        }

                        Task {
                            await vm.saveCategory(
                                category: .init(
                                    name: vm.categoryName,
                                    lowercasedName: vm.categoryName
                                        .trimmingCharacters(
                                            in: .whitespacesAndNewlines
                                        ).lowercased()))
                        }
                        vm.showAddCategory.toggle()
                    })
            }
        ).alert(
            vm.errorMessage ?? "", isPresented: $vm.showError,
            actions: {

                Button {
                    vm.errorMessage = ""
                    vm.showError = false
                } label: {
                    Text("Ok")
                }

            }
        ).navigationTitle("Add Item")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {

                        hideKeyboard()
                        Task {
                            await vm.saveInventory()
                        }

                    } label: {
                        Text("Save")
                    }.disabled(!vm.isValid)
                        .opacity(vm.isValid ? 1 : 0.5)
                        .foregroundStyle(Color.brandPrimary)

                }
            }.onAppear {
                vm.resetValues()
            }
    }
}

#Preview {
    NavigationStack {
        AddEditInventoryView()
    }

}
