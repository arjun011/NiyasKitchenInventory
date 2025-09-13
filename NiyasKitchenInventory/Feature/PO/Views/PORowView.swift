//
//  PORowView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 08/09/25.
//

import SwiftUI

struct PORowView: View {
    let po: POModel
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(po.supplierName).font(.headline)
                Spacer()
                Text(po.status)
                         .font(.caption).bold()
                         .padding(.horizontal, 8).padding(.vertical, 4)
                         .background(po.orderStatus.chipColor.opacity(0.15), in: Capsule())
                         .foregroundStyle(po.orderStatus.chipColor)
            }
            HStack(spacing: 12) {
                
                Label(po.expectedDate?.formatted(date: .long, time: .omitted) ?? "N/A", systemImage: "calendar")
                    .font(.subheadline)
                if let qty = po.lineCount {
                    Label("\(Int(qty))", systemImage: "shippingbox")
                        .font(.subheadline)
                }
            }
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    PORowView(po: mocPOModel)
}

