//
//  DateRangePickerView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 01/01/26.
//

import SwiftUI

struct DateRangePickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var startDate: Date
    @Binding var endDate: Date
    var onApply: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                DatePicker("Start Date", selection: $startDate, displayedComponents: [.date])
                DatePicker("End Date", selection: $endDate, in: startDate..., displayedComponents: [.date])
            }
            .navigationTitle("Select Date Range")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        onApply()
                        dismiss()
                    }
                }
            }
        }
    }
}




