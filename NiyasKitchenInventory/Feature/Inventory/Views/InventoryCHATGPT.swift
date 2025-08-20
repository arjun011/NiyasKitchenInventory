//
//  InventoryCHATGPT.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 17/08/25.
//


import SwiftUI

// MARK: - Safe color tokens with fallbacks
extension Color {
    static var nkTextPrimary: Color   { Color("TextPrimary", bundle: .main)   ?? .primary }
    static var nkTextSecondary: Color { Color("TextSecondary", bundle: .main) ?? .secondary }
    static var nkBrandPrimary: Color  { Color("BrandPrimary", bundle: .main)  ?? .blue }
    static var nkStrokeSoft: Color    { Color("StrokeSoft", bundle: .main)    ?? .gray.opacity(0.2) }
    static var nkDanger: Color        { Color("Danger", bundle: .main)        ?? .red }
}

/// Graceful init that returns nil if the asset isn't present.
private extension Color {
    init?(_ name: String, bundle: Bundle) {
        #if os(iOS)
        if UIColor(named: name) != nil { self = Color(name) } else { return nil }
        #else
        self.init(name)
        #endif
    }
}




// MARK: - View
struct InventoryCHATGPT: View {
    // Source (replace with Firestore later)
    @State private var allItems: [InventoryItemModel] = mockInventory

    // Search & filter state
    @State private var searchText: String = ""
    @State private var showLowStockOnly = false
    @State private var showStaleOnly = false
    @State private var selectedSupplier: String? = nil

    enum SortOption: String, CaseIterable { case nameAZ = "Name (A–Z)", lastUpdatedDesc = "Last Updated (new → old)" }
    @State private var sortOption: SortOption = .nameAZ

    var body: some View {
        
            VStack(spacing: 0) {
                // Filter bar
                FilterBar(
                    suppliers: suppliers,
                    selectedSupplier: $selectedSupplier,
                    showLowStockOnly: $showLowStockOnly,
                    showStaleOnly: $showStaleOnly,
                    sortOption: $sortOption
                )
                .padding(.horizontal, 12)
                .padding(.top, 6)
                .padding(.bottom, 4)

                // List
                if filteredItems.isEmpty {
                    EmptyStateView(
                        title: "No items match",
                        subtitle: "Try clearing filters or searching a different name."
                    )
                    .padding(.top, 48)
                } else {
                    List {
                        ForEach(filteredItems) { item in
                            InventoryRowView1(item: item)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Inventory")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // TODO: Present AddItemView
                    } label: {
                        Image(systemName: "plus.circle.fill").font(.title2)
                    }
                    .accessibilityLabel("Add Item")
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic),
                        prompt: "Search items or SKU")
        
       
    }

    // MARK: - Derived

    private var suppliers: [String] {
        Array(Set(allItems.map { $0.supplierName })).sorted()
    }

    private var filteredItems: [InventoryItemModel] {
        var items = allItems

        // Search by name/SKU
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if !q.isEmpty {
            items = items.filter {
                $0.name.lowercased().contains(q) ||
                ($0.sku?.lowercased().contains(q) ?? false)
            }
        }

        // Supplier filter
        if let s = selectedSupplier {
            items = items.filter { $0.supplierName == s }
        }

        // Chips
        if showLowStockOnly { items = items.filter { $0.isLowStock } }
        if showStaleOnly { items = items.filter { $0.isStale } }

        // Sort
        switch sortOption {
        case .nameAZ:
            items.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .lastUpdatedDesc:
            items.sort { $0.lastUpdated > $1.lastUpdated }
        }
        return items
    }
}

// MARK: - Filter Bar
private struct FilterBar: View {
    let suppliers: [String]
    @Binding var selectedSupplier: String?
    @Binding var showLowStockOnly: Bool
    @Binding var showStaleOnly: Bool
    @Binding var sortOption: InventoryCHATGPT.SortOption

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                // Supplier menu
                Menu {
                    Button("All Suppliers") { selectedSupplier = nil }
                    ForEach(suppliers, id: \.self) { name in
                        Button(name) { selectedSupplier = name }
                    }
                } label: {
                    ChipLabel(text: selectedSupplier ?? "Supplier", icon: "person.2.fill", isActive: selectedSupplier != nil)
                }

                // Low stock toggle
                ToggleChip(isOn: $showLowStockOnly, text: "Low Stock", icon: "exclamationmark.triangle.fill")

                // Stale toggle
                ToggleChip(isOn: $showStaleOnly, text: "Stale (>7d)", icon: "clock.fill")

                // Sort menu
                Menu {
                    ForEach(InventoryCHATGPT.SortOption.allCases, id: \.self) { opt in
                        Button(opt.rawValue) { sortOption = opt }
                    }
                } label: {
                    ChipLabel(text: sortOption.rawValue, icon: "arrow.up.arrow.down", isActive: true)
                }
            }
            .padding(.vertical, 8)
        }
    }
}

// MARK: - Row
private struct InventoryRowView1: View {
    let item: InventoryItemModel

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Leading badge (optional)
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.nkStrokeSoft)
                .frame(width: 6)

            VStack(alignment: .leading, spacing: 2) {
                HStack(alignment: .firstTextBaseline) {
                    Text(item.name)
                        .font(.headline)
                        .foregroundStyle(Color.nkTextPrimary)
                    Spacer()
                    Text("\(formattedQty(item.quantity)) \(item.unit)")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color.nkTextPrimary)
                }

                Text("\(item.supplierName) • Updated \(relative(item.lastUpdated))")
                    .font(.caption)
                    .foregroundStyle(Color.nkTextSecondary)
                    .lineLimit(1)

                if item.isLowStock {
                    Text("LOW STOCK")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.nkDanger, in: Capsule())
                        .padding(.top, 4)
                }
            }
        }
        .padding(.vertical, 6)
        .contentShape(Rectangle())
        // .onTapGesture { /* Navigate to Item Detail later */ }
    }

    private func formattedQty(_ q: Double) -> String {
        q == floor(q) ? String(Int(q)) : String(format: "%.1f", q)
    }

    private func relative(_ date: Date) -> String {
        let r = RelativeDateTimeFormatter()
        r.unitsStyle = .short
        return r.localizedString(for: date, relativeTo: Date())
    }
}

// MARK: - Chips
private struct ChipLabel: View {
    let text: String
    let icon: String
    var isActive: Bool = false

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon).font(.caption.weight(.semibold))
            Text(text).font(.caption.weight(.semibold))
        }
        .foregroundStyle(isActive ? Color.nkBrandPrimary : Color.red)
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            Capsule().fill(.ultraThinMaterial)
                .overlay(Capsule().stroke(Color.nkStrokeSoft, lineWidth: 1))
        )
    }
}

private struct ToggleChip: View {
    @Binding var isOn: Bool
    let text: String
    let icon: String

    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            HStack(spacing: 6) {
                Image(systemName: icon).font(.caption.weight(.semibold))
                Text(text).font(.caption.weight(.semibold))
            }
            .foregroundStyle(isOn ? .white : Color.nkBrandPrimary)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isOn ? Color.nkBrandPrimary : .clear)
                    .overlay(Capsule().stroke(Color.nkBrandPrimary, lineWidth: 1))
            )
        }
        .buttonStyle(.plain)
    }
}



#Preview {
    
    NavigationStack {
        InventoryCHATGPT()
    }
    
    
}


import SwiftUI

struct EmptyStateView: View {
    let title: String
    let subtitle: String?

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "archivebox")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)

            Text(title)
                .font(.headline)
                .multilineTextAlignment(.center)

            if let subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .padding()
    }
}

