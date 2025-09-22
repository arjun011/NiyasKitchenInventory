//
//  ClosingSalesCounter.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 22/09/25.
//

import SwiftUI

struct ClosingSalesCounterView: View {
    @Binding var vm:DailySalesViewModel
    @Environment(AppSession.self) private var session
    
    var body: some View {
        
        Form {
            
            Section {
                ForEach($vm.closingDenominationFields) { $field in
                    HStack {
                        Text(field.label)
                        Spacer()
                        TextField("0", value: $field.count, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 60)
                    }
                }
            } header: {
                Text("Closing Denominations")
            }

            Section {
                Text(vm.totalClosingCash, format: .currency(code: "GBP"))
                    .fontWeight(.bold)
            } header: {
                Text("Total Cash From Counter")
            }

            Section {
                salesField(title: "Card", value: $vm.card)
                salesField(title: "Just Eat", value: $vm.justEat)
                salesField(title: "Uber Eats", value: $vm.uberEats)
                salesField(title: "Deliveroo", value: $vm.deliveroo)
                salesField(title: "Bank", value: $vm.bank)
            } header: {
                Text("Other Collections")
            }

            Section {
                Text(vm.netCashFromCounter, format: .currency(code: "GBP"))
                    .bold()
            } header: {
                Text("Net Cash (Closing - Opening)")
            }

            Section {
                HStack {
                    Text("Total")
                    Spacer()
                    Text("£\(vm.total, specifier: "%.2f")")
                        .bold()

                }
            }

            Section {

                if vm.isClosingSubmitted {
                    Text("✅ Today's sales already submitted.")
                        .foregroundColor(.green)
                } else {
                    RoundedRectangleButton(
                        fill: .brandPrimary, textColor: .white,
                        text: "Submit Closing Sales"
                    ) {

                        Task {
                            do {
                                try await vm.submitClosing(
                                    userId: session.profile?.uid ?? "")
                            } catch {
                                print(
                                    "Error: \(error.localizedDescription)")
                            }
                        }
                    }.disabled(vm.total == 0 || vm.isClosingSubmitted)
                }
            }
        }.onTapGesture {
            hideKeyboard()
        }
    }
    
    func salesField(title: String, value: Binding<Double>) -> some View {
        HStack {
            Text(title)
            Spacer()
            TextField("0.00", value: value, format: .number)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .frame(width: 100)
        }
    }
}

#Preview {
    @Previewable @State  var vm = DailySalesViewModel()
    ClosingSalesCounterView(vm: $vm)
        .environment(AppSession())
}
