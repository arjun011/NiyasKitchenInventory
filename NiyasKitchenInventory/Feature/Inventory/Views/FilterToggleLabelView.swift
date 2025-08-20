//
//  FilterToggleLabelView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 20/08/25.
//

import SwiftUI

struct FilterToggleLabelView: View {

    var icon: String
    var title: String
    @Binding var isOn: Bool

    var body: some View {

        HStack(
            spacing: 5,
            content: {
                Image(systemName: icon).font(
                    .caption.weight(.semibold))
                Text(title)
                    .font(
                        .caption.weight(.semibold))

            }
        ).tint(isOn ?  Color.white : Color.brandPrimary)
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            Capsule().fill(isOn ? Color.brandPrimary : Color.strokeSoft ))

    }
}




#Preview {
    @Previewable @State var isFilter:Bool = false
    FilterToggleLabelView(icon: "", title: "Test", isOn: $isFilter)
}
