//
//  DailySalesChatView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 21/09/25.
//

import Firebase
import SwiftUI

struct DailySalesView: View {
    @State private var vm = DailySalesViewModel()
    @Environment(AppSession.self) private var session

    var body: some View {

        VStack {
            if !vm.isOpeningSubmitted {

                OpeningCashCounterView(vm: $vm)

            } else {

                ClosingSalesCounterView(vm: $vm)

            }
        }.navigationTitle("Daily Sales")
        .task {
            await vm.checkExistingSalesEntry()
        }

    }

   
}

struct DenominationField: Identifiable, Hashable {
    let id = UUID()
    let label: String
    let value: Double
    var count: Int?

    static func defaultFields() -> [DenominationField] {
        return [
            .init(label: "£50", value: 50),
            .init(label: "£20", value: 20),
            .init(label: "£10", value: 10),
            .init(label: "£5", value: 5),
            .init(label: "£2", value: 2),
            .init(label: "£1", value: 1),
            .init(label: "50p", value: 0.5),
            .init(label: "20p", value: 0.2),
            .init(label: "10p", value: 0.1),
            .init(label: "5p", value: 0.05),
            .init(label: "2p", value: 0.02),
            .init(label: "1p", value: 0.01),
        ]
    }
}

#Preview {
    DailySalesView().environment(AppSession())
}
