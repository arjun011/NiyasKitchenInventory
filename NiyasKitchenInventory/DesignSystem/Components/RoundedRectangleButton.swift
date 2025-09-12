//
//  RoundedRectangeButton.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 10/09/25.
//

import SwiftUI

struct RoundedRectangleButton: View {
    var fill: Color
    var textColor: Color
    var text: String
    var action: () -> Void
    var body: some View {

        Button(action: action) {
            Text(text)
                .foregroundStyle(textColor)
                .font(.headline)
                .frame(maxWidth: .infinity, minHeight: 52)  // stretch horizontally
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(fill)
                )
        }.buttonStyle(.plain)
    }
}

#Preview {

    VStack {

        RoundedRectangleButton(
            fill: .brandPrimary, textColor: .white, text: "Send"
        ) {

            print("Send")

        }
    }

}
