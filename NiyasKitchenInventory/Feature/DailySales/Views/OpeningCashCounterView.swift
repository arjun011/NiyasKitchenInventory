//
//  OpeningCashCounter.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 22/09/25.
//

import SwiftUI

struct OpeningCashCounterView: View {
    @Binding var vm:DailySalesViewModel
    @Environment(AppSession.self) private var session
    
    var body: some View {
        
        Form {
            
            Section(header: Text("Today's Date")) {
                Text(vm.today.formatted(date: .abbreviated, time: .omitted))
                    .fontWeight(.semibold)
            }
            
            Section(header: Text("Opening Cash - Count Denominations")) {
                ForEach($vm.openingDenominationFields) { $field in
                    HStack {
                        Text(field.label)
                        Spacer()
                        TextField(
                            "Qty", value: $field.count, format: .number
                        )
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 60)
                    }
                }
            }

            Section {
                HStack {
                    Text("Total Cash")
                    Spacer()
                    Text(
                        vm.totalOpeningCash, format: .currency(code: "GBP")
                    )
                    .fontWeight(.bold)
                }
            }

            Section {

                RoundedRectangleButton(
                    fill: .brandPrimary, textColor: .white,
                    text: "Submit Opening Cash"
                ) {

                    Task {
                        do {
                            try await vm.submitOpening(
                                userId: session.profile?.uid ?? "")
                        } catch {
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                }.disabled(vm.totalOpeningCash == 0)

            }
        }.onTapGesture {
            hideKeyboard()
        }
        
    }
}

#Preview {
    @Previewable @State var vm = DailySalesViewModel()
    OpeningCashCounterView(vm: $vm)
        .environment(AppSession())
}
