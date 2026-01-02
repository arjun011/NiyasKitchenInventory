//
//  CashReportCellView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 01/01/26.
//

import SwiftUI

struct CashReportCellView: View {
    
    var report:CashFlowModel
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            HStack {
                Text("£\(report.ammount, specifier: "%.2f")")
                    .bold()
                    .foregroundColor(report.flowColor)
                    
                Spacer()
                
                Text(report.created.formatted(date: .abbreviated, time: .omitted))
                    
                
            }
            
            Text(report.description)
                .font(.footnote)
                .foregroundColor(.secondary)
            
        }
        
    }
}

#Preview {
    CashReportCellView(report: CashFlowModel(ammount: 100.3, description: "HiteshBhai Salary", created: Date(), createdBy: "xxc", flowType:MovementType.out.rawValue
                                            ))
}
