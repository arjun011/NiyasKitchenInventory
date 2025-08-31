//
//  MovementListRow.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 31/08/25.
//

import SwiftUI

struct MovementListRow: View {
    var movement:MovementModel
    var body: some View {
        
        HStack(
            alignment: .top, spacing: 10,
            content: {

                Image(systemName: movement.mType.icon)
                    .foregroundStyle(movement.mType.tint)
                    .font(.title)

                
                VStack(alignment: .leading) {
                    
                    HStack(
                        alignment: .firstTextBaseline, spacing: 4
                    ) {

                        Text(movement.itemName)
                            .fontWeight(.semibold)

                        Text(movement.displayQuantityFormate)
                            .foregroundStyle(Color.secondary)
                            .font(.footnote)

                        Spacer()

                        Text(
                            movement.createdAt.formatted(
                                date: .long, time: .omitted)
                        )
                        .foregroundStyle(Color.secondary)
                        .font(.footnote)


                    }.frame(maxWidth: .infinity)
                    
                    if movement.mType == .in, movement.supplierName != nil {
                        
                        Label(movement.supplierName ?? "", systemImage: "person.2")
                            .listItemTint(Color.brandPrimary)
                            .font(.callout)
                    }

                    if let note = movement.note, !note.isEmpty {
                        Text("• \(note)")
                            .font(.footnote)
                            .lineLimit(3, reservesSpace: false)
                    }
                    
                }
                
                
            })
        
    }
}

#Preview {
    MovementListRow(movement: MovementModel.init(itemId: "xce", itemName: "Tometo", type: "IN", quantity: 34.3, unitName: "KG", unitId: "ert", createdAt: Date(), createdBy: "Arjun Patel"))
}
