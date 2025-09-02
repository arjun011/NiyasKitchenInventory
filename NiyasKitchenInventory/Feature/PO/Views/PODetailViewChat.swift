//
//  PODetailViewChat.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 02/09/25.
//

import SwiftUI

struct PODetailView: View {
    var body: some View {
        List {
            Section {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Fresh Farms Ltd").font(.headline)
                        Text("Status: SENT").foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text("Created: \(Date().formatted(date: .abbreviated, time: .shortened))")
                        .font(.footnote).foregroundStyle(.secondary)
                }
            }
            Section("Lines") {
                HStack { Text("Tomatoes"); Spacer(); Text("10 kg") }
                HStack { Text("Onions");   Spacer(); Text("5 kg") }
            }
        }
        .navigationTitle("PO-Preview")
    }
}
