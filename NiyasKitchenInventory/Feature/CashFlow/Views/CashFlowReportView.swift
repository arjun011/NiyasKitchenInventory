//
//  CashFlowReportView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 01/01/26.
//

import SwiftUI

struct CashFlowReportView: View {

    @State private var vm = CashFlowReportViewModel()

    var body: some View {

        List {
            Section {
                dateRangeButton
            }
            
            Section("Available cash") {
                Text("£\(vm.remaningCash, specifier: "%.2f")")
            }

            Section {
                ForEach(vm.cashFlowReport, id: \.id) { report in
                    CashReportCellView(report: report)
                }
            }
        }.task {
            await vm.loadReport()
        }.sheet(isPresented: $vm.showDatePicker) {

            DateRangePickerView(startDate: $vm.startDate, endDate: $vm.endDate) {
                
                Task {
                    await vm.loadReport()
                }
               
            }

        }.navigationTitle("Cash Report")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.topBarTrailing) {

                    NavigationLink {
                        CashFlowView()
                    } label: {
                        Image(systemName: "plus")
                            .tint(.brandPrimary)
                    }

                }
            }
    }

    private var dateRangeButton: some View {
        Button {
            vm.showDatePicker = true
        } label: {
            HStack {
                Text(vm.startDate.formatted(date: .abbreviated, time: .omitted))
                Text("-")
                Text(vm.endDate.formatted(date: .abbreviated, time: .omitted))
                Image(systemName: "calendar")
            }
            .padding(8)
            .cornerRadius(8)
        }
    }

}

#Preview {

    NavigationStack {
        CashFlowReportView()
    }

}
