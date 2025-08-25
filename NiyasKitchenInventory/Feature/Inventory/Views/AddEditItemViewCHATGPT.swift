//
//  AddEditItemViewCHATGPT.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 20/08/25.
//

import SwiftUI

import SwiftUI

// MARK: - Mock Supplier model (static for now)
//struct SupplierModel: Identifiable, Hashable {
//    let id = UUID()
//    var name: String
//    var phone: String?
//    var email: String?
//}
//
//fileprivate let mockSuppliersSeed: [SupplierModel] = [
//    .init(name: "Fresh Farms Ltd", phone: "+44 7123 456789", email: "contact@freshfarms.com"),
//    .init(name: "DairyLand", phone: "+44 7000 111222", email: "info@dairyland.com"),
//    .init(name: "SpiceTrade Co.", phone: nil, email: "hello@spicetrade.co")
//]

// MARK: - Add/Edit Item View (static)
struct AddEditItemView: View {
    enum Mode { case add, edit }
    let mode: Mode

    // Form fields
    @State private var name: String = ""
    @State private var sku: String = ""
    @State private var quantity: String = ""
    @State private var unit: String = "kg"
    @State private var lowStockThreshold: String = ""
    @State private var category: String = ""
    @State private var note: String = ""

    // Supplier
    @State private var suppliers: [SupplierModel] = mockSuppliersSeed
    @State private var selectedSupplier: SupplierModel? = nil
    @State private var showAddSupplier = false

    // UI state
    @Environment(\.dismiss) private var dismiss
    @State private var showValidation = false

    // Allowed units
    private let units = ["kg", "g", "L", "ml", "pcs"]

    // Validation
    private var isValid: Bool {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }
        guard Double(quantity) != nil, Double(quantity)! >= 0 else { return false }
        if let th = Double(lowStockThreshold), th >= 0 { /* ok */ } else { return false }
        return selectedSupplier != nil
    }

    var body: some View {
        NavigationStack {
            Form {
                // BASICS
                Section("Basics") {
                    TextField("Item name", text: $name)
                        .textInputAutocapitalization(.words)
                        .submitLabel(.done)

                    TextField("SKU (optional)", text: $sku)
                        .textInputAutocapitalization(.never)

                    HStack(spacing: 12) {
                        TextField("Quantity", text: $quantity)
                            .keyboardType(.decimalPad)
                        Picker("Unit", selection: $unit) {
                            ForEach(units, id: \.self) { Text($0) }
                        }
                        .pickerStyle(.menu)
                    }

                    HStack(spacing: 12) {
                        TextField("Low‑stock threshold", text: $lowStockThreshold)
                            .keyboardType(.decimalPad)
                        Text("Alert when qty ≤ threshold")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    TextField("Category (e.g. Vegetables, Dairy)", text: $category)
                        .textInputAutocapitalization(.words)
                }

                // SUPPLIER
                Section {
                    Menu {
                        Picker("Supplier", selection: $selectedSupplier) {
                            Text("Select supplier").tag(SupplierModel?.none)
                            ForEach(suppliers) { sup in
                                Text(sup.name).tag(Optional(sup))
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "person.2.fill")
                                .foregroundStyle(Color("BrandPrimary"))
                            Text(selectedSupplier?.name ?? "Choose supplier")
                                .foregroundStyle(selectedSupplier == nil ? .secondary : Color("TextPrimary"))
                            Spacer()
                            Image(systemName: "chevron.down").font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }

                    Button {
                        showAddSupplier = true
                    } label: {
                        Label("Add Supplier", systemImage: "plus.circle.fill")
                    }
                } header: {
                    Text("Supplier")
                } footer: {
                    if selectedSupplier == nil, showValidation {
                        Text("Supplier is required.")
                            .foregroundStyle(.red)
                    }
                }

                // NOTES
                Section("Notes (optional)") {
                    TextField("Notes about item (brand, packaging, etc.)", text: $note, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                }
            }
            .navigationTitle(mode == .add ? "Add Item" : "Edit Item")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if isValid {
                            // later: call ViewModel/repository
                            dismiss()
                        } else {
                            showValidation = true
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                    }
                    .disabled(!isValid)
                }
            }
            .sheet(isPresented: $showAddSupplier) {
                AddSupplierSheet { newSupplier in
                    suppliers.append(newSupplier)
                    selectedSupplier = newSupplier
                }
            }
        }
    }
}

// MARK: - Add Supplier Sheet (static)
struct AddSupplierSheet: View {
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var phone: String = ""
    @State private var email: String = ""

    var onSave: (SupplierModel) -> Void

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Supplier") {
                    TextField("Name", text: $name)
                        .textInputAutocapitalization(.words)

                    TextField("Phone (optional)", text: $phone)
                        .keyboardType(.phonePad)

                    TextField("Email (optional)", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                }
            }
            .navigationTitle("Add Supplier")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(.init(name: name,
                                     phone: phone.isEmpty ? nil : phone,
                                     email: email.isEmpty ? nil : email))
                        dismiss()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    AddEditItemView(mode: .add)
        .environment(\.colorScheme, .light)
}
