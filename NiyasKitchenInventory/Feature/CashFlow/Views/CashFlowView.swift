//
//  CashFlowView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 28/12/25.
//

import SwiftUI

struct CashFlowView: View {
    @Environment(AppSession.self) private var session
    @Environment(\.dismiss) private var dismiss
    @State private var vm = CashFlowViewModel()
    @State private var selectedDate:Date = Date()
    
    var body: some View {

        ZStack {

            Form {
                Section {
                    
                    DatePicker("Date", selection: $selectedDate, in: ...Date(), displayedComponents: [.date])
                    
                    Text(
                        "\(Date().formatted(date: .abbreviated, time: .omitted))"
                    )
                }

                Section("Flow") {

                    Picker("", selection: $vm.flowType) {
                        ForEach([MovementType.in, .out]) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }.pickerStyle(.segmented)
                }

                Section("Cash") {
                    TextField("0", text: $vm.ammount)
                        .keyboardType(.decimalPad)
                }

                Section("Description") {
                    TextField("", text: $vm.description, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                }
                
                Section {
                    if !vm.errorMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Text(vm.errorMessage)
                            .foregroundStyle(Color.red)
                            .font(.headline)
                    }
                }

            }.onTapGesture {
                hideKeyboard()
            }
            .navigationTitle("Cash Flow")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        Task {
                             await self.vm.saveCashFlow(by: session.profile?.uid ?? "", dateSubmitted: selectedDate)
                            
                            if vm.errorMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                await MainActor.run {
                                    dismiss()
                                }
                            }
                            
                        }
                    }.fontWeight(.semibold)
                        .disabled(!vm.isValidate)

                }
            }

        }

    }
}

#Preview {

    NavigationStack {
        CashFlowView()
            .environment(AppSession())
    }

}

