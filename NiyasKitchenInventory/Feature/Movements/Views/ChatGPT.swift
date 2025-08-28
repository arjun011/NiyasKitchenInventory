//
//  ChatGPT.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 27/08/25.
//

import SwiftUI

// MARK: - ROUTING

enum MovementType: String, CaseIterable, Identifiable, Hashable {
    case all = "ALL", `in` = "IN", out = "OUT", waste = "WASTE"
    var id: String { rawValue }
    var icon: String {
        switch self {
        case .in: return "arrow.down.circle.fill"
        case .out: return "arrow.up.circle.fill"
        case .waste: return "trash.circle.fill"
        case .all: return "circle.grid.2x2.fill"
        }
    }
    var tint: Color {
        switch self {
        case .in: return .green
        case .out: return .brandPrimary
        case .waste: return .red
        case .all: return .gray
        }
    }
}

enum RangeFilter: String, CaseIterable, Identifiable, Hashable {
    case today = "Today", d7 = "7 Days", d30 = "30 Days", all = "All Time"
    var id: String { rawValue }
}

// Demo types
struct DemoItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let unit: String
    let quantity: Double
    let lowStock: Double
    let supplier: String
    let category: String
}

struct DemoMovement: Identifiable, Hashable {
    let id = UUID()
    let item: DemoItem
    let type: MovementType
    let qty: Double
    let note: String?
    let date: Date
    var unit: String { item.unit }
}

enum Route: Hashable {
    case addMovement(item: DemoItem)
    case itemDetail(item: DemoItem)
    case itemMovements(item: DemoItem)
}

// MARK: - ROOT CONTAINER

struct MovementsFlowRoot: View {
    @State private var path: [Route] = []
    @State private var showSelectItem = false

    // Demo data
    private let items: [DemoItem] = [
        .init(name: "Tomatoes", unit: "kg", quantity: 24, lowStock: 5, supplier: "Fresh Farms Ltd", category: "Vegetables"),
        .init(name: "Onions", unit: "kg", quantity: 18, lowStock: 5, supplier: "Agro Supply Co.", category: "Vegetables"),
        .init(name: "Milk", unit: "L", quantity: 12, lowStock: 4, supplier: "Dairy Pro", category: "Dairy")
    ]
    @State private var movements: [DemoMovement] = []

    init() {
        // Seed demo movements
        let now = Date()
        let tomatoes = DemoItem(name: "Tomatoes", unit: "kg", quantity: 24, lowStock: 5, supplier: "Fresh Farms Ltd", category: "Vegetables")
        let onions    = DemoItem(name: "Onions", unit: "kg", quantity: 18, lowStock: 5, supplier: "Agro Supply Co.",    category: "Vegetables")
        let milk      = DemoItem(name: "Milk", unit: "L", quantity: 12, lowStock: 4, supplier: "Dairy Pro",             category: "Dairy")
        _movements = State(initialValue: [
            .init(item: tomatoes, type: .in,    qty: 12, note: "Morning delivery", date: now.addingTimeInterval(-3600)),
            .init(item: onions,   type: .out,   qty: 5,  note: "Lunch prep",       date: now.addingTimeInterval(-7200)),
            .init(item: milk,     type: .waste, qty: 2,  note: "Expired",          date: now.addingTimeInterval(-86400))
        ])
    }

    var body: some View {
        NavigationStack(path: $path) {
            MovementsListView(
                movements: movements,
                onTapRow: { movement in
                    path.append(.itemDetail(item: movement.item))
                },
                onTapAdd: { showSelectItem = true }
            )
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .addMovement(let item):
                    AddMovementView(
                        item: item,
                        onSave: { m in
                            movements.insert(m, at: 0) // prepend to feed
                        }
                    )
                case .itemDetail(let item):
                    ItemDetailView(
                        item: item,
                        onSeeAll: { path.append(.itemMovements(item: item)) },
                        onQuickAdd: { type in
                            path.append(.addMovement(item: item))
                        }
                    )
                case .itemMovements(let item):
                    ItemMovementsListView(item: item, all: movements)
                }
            }
            .sheet(isPresented: $showSelectItem) {
                NavigationStack {
                    SelectItemView(
                        items: items,
                        onSelect: { item in
                            showSelectItem = false
                            // Navigate to Add Movement
                            path.append(.addMovement(item: item))
                        }
                    )
                }
                .presentationDetents([.medium, .large])
            }
            .navigationTitle("Movements")
        }
    }
}

// MARK: - MOVEMENTS LIST (GLOBAL FEED)

struct MovementsListView: View {
    let movements: [DemoMovement]
    let onTapRow: (DemoMovement) -> Void
    let onTapAdd: () -> Void

    @State private var type: MovementType = .all
    @State private var range: RangeFilter = .today
    @State private var query: String = ""

    var filtered: [DemoMovement] {
        movements.filter { m in
            (type == .all || m.type == type)
            && matchesRange(m.date)
            && (query.isEmpty
                || m.item.name.localizedCaseInsensitiveContains(query)
                || (m.note ?? "").localizedCaseInsensitiveContains(query)
                || m.item.supplier.localizedCaseInsensitiveContains(query))
        }
        .sorted { $0.date > $1.date }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Filters
            Picker("Type", selection: $type) {
                ForEach(MovementType.allCases) { t in Text(t.rawValue).tag(t) }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            HStack {
                Menu {
                    Picker("Range", selection: $range) {
                        ForEach(RangeFilter.allCases) { r in Text(r.rawValue).tag(r) }
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "calendar")
                        Text(range.rawValue)
                    }
                    .padding(.horizontal, 10).padding(.vertical, 6)
                    .background(.thinMaterial, in: Capsule())
                }

                Spacer()

                Button {
                    onTapAdd()
                } label: {
                    Label("Add", systemImage: "plus.circle.fill")
                        .labelStyle(.iconOnly)
                }
                .tint(.brandPrimary)
            }
            .padding(.horizontal)
            .padding(.top, 8)

            // Search
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                TextField("Search item, note or supplier", text: $query)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
            }
            .padding(10)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10))
            .padding([.horizontal, .top])

            // List
            if filtered.isEmpty {
                EmptyStateView(
                    title: "No movements yet",
                    subtitle: "Try a different filter or add a movement."
                )
                .padding()
                Spacer()
            } else {
                List {
                    ForEach(filtered) { m in
                        Button {
                            onTapRow(m)
                        } label: {
                            MovementRow(m: m)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
    }

    private func matchesRange(_ date: Date) -> Bool {
        switch range {
        case .today: return Calendar.current.isDateInToday(date)
        case .d7:
            return date >= Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        case .d30:
            return date >= Calendar.current.date(byAdding: .day, value: -30, to: Date())!
        case .all: return true
        }
    }
}

private struct MovementRow: View {
    let m: DemoMovement

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: m.type.icon)
                .font(.title3)
                .foregroundStyle(m.type.tint)
                .frame(width: 28)
            VStack(alignment: .leading, spacing: 2) {
                Text("\(m.item.name) \(sign) \(trimZero(m.qty)) \(m.unit)")
                    .font(.subheadline).fontWeight(.semibold)
                HStack(spacing: 6) {
                    if !m.item.supplier.isEmpty {
                        Label(m.item.supplier, systemImage: "person.2")
                    }
                    if let note = m.note, !note.isEmpty {
                        Text("• \(note)")
                    }
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
            }
            Spacer()
            Text(m.date.formatted(date: .abbreviated, time: .shortened))
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 6)
    }

    private var sign: String { m.type == .in ? "+" : "-" }
    private func trimZero(_ d: Double) -> String {
        d == floor(d) ? String(Int(d)) : String(format: "%.1f", d)
    }
}

private struct EmptyStateView: View {
    let title: String
    let subtitle: String
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 36, weight: .semibold))
                .foregroundStyle(.secondary)
            Text(title).font(.headline)
            Text(subtitle).font(.subheadline).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }
}

// MARK: - SELECT ITEM (SHEET)

struct SelectItemView: View {
    let items: [DemoItem]
    let onSelect: (DemoItem) -> Void

    @State private var search = ""
    private var filtered: [DemoItem] {
        search.isEmpty ? items : items.filter { $0.name.localizedCaseInsensitiveContains(search) }
    }

    var body: some View {
        List {
            ForEach(filtered) { item in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.name).fontWeight(.semibold)
                        Text("Current: \(Int(item.quantity)) \(item.unit)")
                            .font(.footnote).foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right").foregroundStyle(.secondary)
                }
                .contentShape(Rectangle())
                .onTapGesture { onSelect(item) }
            }
        }
        .searchable(text: $search)
        .navigationTitle("Select Item")
    }
}

// MARK: - ADD MOVEMENT (STATIC)

struct AddMovementView: View {
    let item: DemoItem
    let onSave: (DemoMovement) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var type: MovementType = .in
    @State private var qty: String = ""
    @State private var note: String = ""
    @State private var supplier: String? = nil
    @State private var showSupplierPicker = false

    private var isValid: Bool {
        guard let q = Double(qty), q > 0 else { return false }
        if type == .in { return supplier != nil && !(supplier ?? "").isEmpty }
        return true
    }

    var body: some View {
        Form {
            Section {
                HStack {
                    Text(item.name).font(.headline)
                    Spacer()
                    Text("Unit: \(item.unit)")
                        .foregroundStyle(.secondary)
                }
            }
            Section("Type") {
                Picker("Type", selection: $type) {
                    ForEach([MovementType.in, .out, .waste]) { t in
                        Text(t.rawValue).tag(t)
                    }
                }
                .pickerStyle(.segmented)
            }
            Section("Quantity") {
                TextField("Enter quantity", text: $qty)
                    .keyboardType(.decimalPad)
            }
            if type == .in {
                Section("Supplier") {
                    Button {
                        showSupplierPicker = true
                    } label: {
                        HStack {
                            Image(systemName: "person.2.fill").foregroundStyle(.brandPrimary)
                            Text(supplier ?? "Select supplier")
                                .foregroundStyle(supplier == nil ? .secondary : .primary)
                            Spacer()
                            Image(systemName: "chevron.down").font(.footnote).foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 2)
                    }
                }
            }
            Section("Note (optional)") {
                TextField("Reason / batch / prep note", text: $note, axis: .vertical)
                    .lineLimit(3, reservesSpace: true)
            }
        }
        .navigationTitle("Add Movement")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    let q = Double(qty) ?? 0
                    let m = DemoMovement(item: item, type: type, qty: q, note: note.isEmpty ? nil : note, date: Date())
                    onSave(m)
                    dismiss()
                }
                .disabled(!isValid)
                .tint(.brandPrimary)
            }
        }
        .sheet(isPresented: $showSupplierPicker) {
            NavigationStack {
                List {
                    ForEach(["Fresh Farms Ltd", "Agro Supply Co.", "Green Valley"], id: \.self) { s in
                        HStack {
                            Text(s)
                            Spacer()
                            if s == supplier {
                                Image(systemName: "checkmark.circle.fill").foregroundStyle(.brandPrimary)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture { supplier = s }
                    }
                }
                .navigationTitle("Select Supplier")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") { showSupplierPicker = false }
                    }
                }
            }
            .presentationDetents([.medium, .large])
        }
    }
}

// MARK: - ITEM DETAIL (STATIC)

struct ItemDetailView: View {
    let item: DemoItem
    let onSeeAll: () -> Void
    let onQuickAdd: (MovementType) -> Void

    var isLow: Bool { item.quantity <= item.lowStock }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(item.name).font(.title2).fontWeight(.semibold)
                        Spacer()
                        Text("\(Int(item.quantity)) \(item.unit)")
                            .font(.title2).fontWeight(.bold)
                            .foregroundStyle(.brandPrimary)
                    }
                    HStack(spacing: 8) {
                        Text("SKU —").foregroundStyle(.secondary) // placeholder
                        Text("Category: \(item.category)").foregroundStyle(.secondary)
                        Text("•").foregroundStyle(.secondary)
                        Text(item.supplier).foregroundStyle(.secondary)
                    }
                    if isLow {
                        Label("Low stock", systemImage: "exclamationmark.triangle.fill")
                            .font(.caption).foregroundStyle(.white)
                            .padding(.horizontal, 8).padding(.vertical, 4)
                            .background(Color.appWarning, in: Capsule())
                    }
                }
                .padding(16)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
                .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
                .padding(.horizontal)

                // Quick Actions
                HStack(spacing: 12) {
                    PillButton(title: "IN", systemName: "arrow.down.circle.fill", tint: .green)  { onQuickAdd(.in) }
                    PillButton(title: "OUT", systemName: "arrow.up.circle.fill", tint: .brandPrimary) { onQuickAdd(.out) }
                    PillButton(title: "WASTE", systemName: "trash.circle.fill", tint: .red) { onQuickAdd(.waste) }
                }
                .padding(.horizontal)

                // Recent (static placeholder)
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Recent Movements").font(.headline)
                        Spacer()
                        Button("See all") { onSeeAll() }.font(.subheadline)
                    }
                    .padding(.horizontal)

                    VStack(spacing: 0) {
                        // placeholder rows
                        MovementRow(m: .init(item: item, type: .in, qty: 10, note: "Delivery", date: .now.addingTimeInterval(-3600)))
                        Divider().padding(.leading, 56)
                        MovementRow(m: .init(item: item, type: .out, qty: 6, note: "Prep", date: .now.addingTimeInterval(-7200)))
                    }
                    .padding(12)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                }
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("Item Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct PillButton: View {
    let title: String
    let systemName: String
    let tint: Color
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemName)
                .font(.headline)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(tint)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.06), radius: 6, y: 3)
    }
}

// MARK: - ITEM MOVEMENTS (PER-ITEM FEED, STATIC)

struct ItemMovementsListView: View {
    let item: DemoItem
    let all: [DemoMovement]

    @State private var type: MovementType = .all
    @State private var range: RangeFilter = .d7

    var filtered: [DemoMovement] {
        all.filter { $0.item == item }
           .filter { type == .all ? true : $0.type == type }
           .sorted { $0.date > $1.date }
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(item.name).font(.title3).fontWeight(.semibold)
                Spacer()
                Menu {
                    Picker("Range", selection: $range) {
                        ForEach(RangeFilter.allCases) { r in Text(r.rawValue).tag(r) }
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "calendar")
                        Text(range.rawValue)
                    }
                    .padding(.horizontal, 10).padding(.vertical, 6)
                    .background(.thinMaterial, in: Capsule())
                }
            }
            .padding([.horizontal, .top])

            Picker("Type", selection: $type) {
                ForEach(MovementType.allCases) { t in Text(t.rawValue).tag(t) }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            if filtered.isEmpty {
                EmptyStateView(title: "No movements", subtitle: "Try a different filter.")
                    .padding()
                Spacer()
            } else {
                List {
                    ForEach(filtered) { m in
                        MovementRow(m: m)
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("Movements")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - PREVIEW

#Preview {
    MovementsFlowRoot()
}
