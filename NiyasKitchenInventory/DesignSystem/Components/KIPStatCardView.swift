//
//  KIPStatCardView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 16/08/25.
//

import SwiftUI

struct KIPStatCardView: View {

    var title: String
    var value: Int
    var icon: String
    var bgColor: Color
    var action: () -> Void

    var body: some View {

        Button {
            action()

        } label: {

            HStack(alignment: .center, spacing: 12) {

                Image(systemName: icon)
                    .font(.system(size: 22, weight: .semibold))
                    .tint(bgColor)

                VStack(alignment: .leading) {
                    Text("\(value)")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(bgColor)

                    Text(title)
                        .font(.subheadline)
                        .foregroundStyle(bgColor)
                        .lineLimit(2)
                }

                Spacer()

            }.padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.appSecondary)
                )

        }.padding(.horizontal)

    }
}

#Preview {
    KIPStatCardView(
        title: "Total Items", value: 100, icon: "cube.box.fill",
        bgColor: Color.appWarning) {
            print("Action")
        }
}
