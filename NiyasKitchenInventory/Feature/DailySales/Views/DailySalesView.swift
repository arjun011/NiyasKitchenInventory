//
//  DailySalesView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 20/09/25.
//

import SwiftUI

struct DailySalesView: View {
    
    @State private var vm = DailySalesViewModel()
    @Environment(AppSession.self) private var session

    var body: some View {
        
            Form {
                
                Section {
                    
                    Text(Date().formatted(date: .abbreviated, time: .omitted))
                        .fontWeight(.semibold)
                }

                Section(header: Text("Today: \(Date().formatted(date: .long, time: .omitted))")) {
                    salesField(title: "Card", value: $vm.card)
                    salesField(title: "Cash", value: $vm.cash)
                    salesField(title: "Just Eat", value: $vm.justEat)
                    salesField(title: "Uber Eats", value: $vm.uberEats)
                    salesField(title: "Bank", value: $vm.bank)
                }

                Section {
                    HStack {
                        Text("Total")
                        Spacer()
                        Text("\(vm.total, specifier: "%.2f") £")
                                                   .bold()
                        
                    }
                }

                if !vm.hasSubmittedToday {
                    Section {
                        Button("Submit") {
                            Task {
                                do {
                                    try await vm.saveEntry(for: session.profile?.uid ?? "")
                                    print("Saved")
                                } catch {
                                    print("Error saving: \(error.localizedDescription)")
                                }
                            }
                        }
                        .disabled(vm.total == 0.0)
                    }
                } else {
                    Section {
                        Text("✅ Today's sales already submitted.")
                            .foregroundColor(.green)
                    }
                }
                
            }.onAppear {
                Task {
                    await vm.checkIfAlreadySubmitted()
                }
            }
            .navigationTitle("Daily Sales")
            
        
    }

    func salesField(title: String, value: Binding<Double>) -> some View {
        HStack {
            Text(title)
            Spacer()
            TextField("0.00", value: value, format: .number)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .frame(width: 100)
                .disabled(vm.hasSubmittedToday)
        }
    }
}


#Preview {
    
    NavigationStack {
        DailySalesView().environment(AppSession())
    }
    
    
}
