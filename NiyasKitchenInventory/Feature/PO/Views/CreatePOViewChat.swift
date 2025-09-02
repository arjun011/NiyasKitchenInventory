//
//  CreatePOViewChat.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 02/09/25.
//

import SwiftUI

struct CreatePOViewChat: View {
    // callbacks
    var onDone: () -> Void

    // local state (static)
    @State private var supplierName: String? = nil
    @State private var supplierEmail: String = ""
    @State private var expectedDate: Date = Date().addingTimeInterval(2*86400)
    @State private var notes: String = ""
    @State private var showSupplierPicker = false
    @State private var lines: [Line] = []
    @State private var showItemPicker = false

    struct Line: Identifiable, Hashable {
        let id = UUID()
        var itemName: String
        var unitName: String
        var qty: String
    }

    // demo suppliers/items
    private let demoSuppliers = ["Fresh Farms Ltd", "Agro Supply Co.", "Dairy Pro"]
    private let demoItems = [
        (name: "Tomatoes", unit: "kg"),
        (name: "Onions",   unit: "kg"),
        (name: "Milk",     unit: "L")
    ]

    var canSaveDraft: Bool {
        supplierName != nil && !lines.isEmpty && lines.allSatisfy { Double($0.qty) ?? 0 > 0 }
    }

    var body: some View {
        Form {
            Section("Supplier") {
                Button {
                    showSupplierPicker = true
                } label: {
                    HStack {
                        Image(systemName: "building.2.fill").foregroundStyle(.brandPrimary)
                        Text(supplierName ?? "Select supplier")
                            .foregroundStyle(supplierName == nil ? .secondary : .primary)
                        Spacer()
                        Image(systemName: "chevron.down").font(.footnote).foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 2)
                }
                TextField("Supplier email (optional)", text: $supplierEmail)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
            }

            Section("Expected date") {
                DatePicker("Delivery date", selection: $expectedDate, displayedComponents: .date)
            }

            Section("Items") {
                if lines.isEmpty {
                    Text("No items yet").foregroundStyle(.secondary)
                } else {
                    ForEach($lines) { $line in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(line.itemName).fontWeight(.semibold)
                                Text(line.unitName).font(.footnote).foregroundStyle(.secondary)
                            }
                            Spacer()
                            TextField("Qty", text: $line.qty)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 80)
                        }
                    }
                    .onDelete { indexSet in lines.remove(atOffsets: indexSet) }
                }
                Button {
                    showItemPicker = true
                } label: {
                    Label("Add item", systemImage: "plus.circle.fill")
                }
            }

            Section("Notes (optional)") {
                TextField("Delivery instructions, contact, etc.", text: $notes, axis: .vertical)
                    .lineLimit(3, reservesSpace: true)
            }
        }
        .navigationTitle("New Purchase Order")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) { Button("Cancel", role: .cancel) { onDone() } }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save Draft") {
                    // TODO: call service to create PO + lines subcollection
                    onDone()
                }
                .disabled(!canSaveDraft)
                .tint(.brandPrimary)
            }
        }
        .sheet(isPresented: $showSupplierPicker) {
            NavigationStack {
                List(demoSuppliers, id: \.self) { name in
                    HStack {
                        Text(name)
                        Spacer()
                        if name == supplierName { Image(systemName: "checkmark.circle.fill").foregroundStyle(.brandPrimary) }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture { supplierName = name }
                }
                .navigationTitle("Select Supplier")
                .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Done") { showSupplierPicker = false } } }
            }
            .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showItemPicker) {
            NavigationStack {
                List(demoItems, id: \.name) { item in
                    Button {
                        lines.append(.init(itemName: item.name, unitName: item.unit, qty: "1"))
                    } label: {
                        HStack {
                            Text(item.name)
                            Spacer()
                            Text(item.unit).foregroundStyle(.secondary)
                        }
                    }
                }
                .navigationTitle("Add Item")
                .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Done") { showItemPicker = false } } }
            }
            .presentationDetents([.medium, .large])
        }
    }
}

#Preview { NavigationStack { CreatePOViewChat(onDone: {}) } }
