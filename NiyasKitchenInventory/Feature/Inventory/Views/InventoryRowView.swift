//
//  InventoryRowView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 17/08/25.
//

import SwiftUI

struct InventoryRowView: View {
    
    var item:InventoryItemModel
    
    var body: some View {
        HStack(alignment: .center) {

            VStack(alignment: .leading) {

                HStack(alignment: .top) {

                    Text(item.name)
                        .font(.headline)
                        .foregroundStyle(Color.brandPrimary)

                    Spacer()

                    Text("\(item.formattedQuantity) \(item.unit)")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color.brandPrimary)
                }

                Text("\(item.supplierName) • Updated \(item.relativeDate)")
                    .font(.caption)
                    .foregroundStyle(Color.brandPrimary)
                    .lineLimit(1)

                if item.isLowStock {
                    Text("LOW STOCK")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.appDanger, in: Capsule())
                        .padding(.top, 4)
                }

            }

        }
    }
}

#Preview {
    InventoryRowView(item: mockInventory[0])
}
