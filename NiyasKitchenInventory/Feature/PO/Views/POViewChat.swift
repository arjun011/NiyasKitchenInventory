//
//  POView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 02/09/25.
//

import SwiftUI


enum POStatus: String, CaseIterable, Identifiable {
    case all = "All", draft = "DRAFT", sent = "SENT", partial = "PARTIAL", received = "RECEIVED", closed = "CLOSED", canceled = "CANCELED"
    var id: String { rawValue }
    var chipColor: Color {
        switch self {
        case .draft: return .gray
        case .sent: return .brandPrimary
        case .partial: return .orange
        case .received: return .green
        case .closed: return .secondary
        case .canceled: return .red
        case .all: return .secondary
        }
    }
}

struct POListView: View {
    struct PO: Identifiable, Hashable {
        let id = UUID()
        let supplierName: String
        let status: POStatus
        let createdAt: Date
        let expectedDate: Date?
        let lineCount: Int
    }

    @State private var filter: POStatus = .all
    @State private var showCreate = false
    @State private var navSelection: PO? = nil

    // demo
    private let demo: [PO] = [
        .init(supplierName: "Fresh Farms Ltd", status: .sent, createdAt: .now.addingTimeInterval(-3600), expectedDate: .now.addingTimeInterval(2*86400), lineCount: 4),
        .init(supplierName: "Agro Supply Co.", status: .partial, createdAt: .now.addingTimeInterval(-2*86400), expectedDate: .now.addingTimeInterval(1*86400), lineCount: 3),
        .init(supplierName: "Dairy Pro", status: .received, createdAt: .now.addingTimeInterval(-7*86400), expectedDate: nil, lineCount: 2),
    ]

    var filtered: [PO] {
        demo.filter { filter == .all ? true : $0.status == filter }
            .sorted { $0.createdAt > $1.createdAt }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Status", selection: $filter) {
                    ForEach(POStatus.allCases) { s in Text(s.rawValue).tag(s) }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                if filtered.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "cart.badge.plus")
                            .font(.system(size: 36, weight: .semibold))
                            .foregroundStyle(.secondary)
                        Text("No purchase orders").font(.headline)
                        Text("Tap + to create a new order.").font(.subheadline).foregroundStyle(.secondary)
                    }
                    .padding(.top, 48)
                    Spacer()
                } else {
                    List(filtered) { po in
                        Button {
                            navSelection = po
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(po.supplierName).fontWeight(.semibold)
                                    HStack(spacing: 8) {
                                        statusChip(po.status)
                                        Text("Lines: \(po.lineCount)").foregroundStyle(.secondary)
                                        if let due = po.expectedDate {
                                            Text("• Due \(due.formatted(date: .abbreviated, time: .omitted))")
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                    .font(.footnote)
                                }
                                Spacer()
                                Text(po.createdAt.formatted(date: .abbreviated, time: .shortened))
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 6)
                        }
                        .buttonStyle(.plain)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Purchase Orders")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showCreate = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .tint(.brandPrimary)
                }
            }
            .sheet(isPresented: $showCreate) {
                NavigationStack {
                    CreatePOViewChat(onDone: { showCreate = false })
                }
                .presentationDetents([.large])
            }
            .navigationDestination(item: $navSelection) { _ in
                PODetailView() // static detail placeholder
            }
        }
    }

    @ViewBuilder
    private func statusChip(_ status: POStatus) -> some View {
        Text(status.rawValue)
            .font(.caption).fontWeight(.semibold)
            .foregroundStyle(.white)
            .padding(.horizontal, 8).padding(.vertical, 4)
            .background(status.chipColor, in: Capsule())
    }
}

#Preview { POListView() }
