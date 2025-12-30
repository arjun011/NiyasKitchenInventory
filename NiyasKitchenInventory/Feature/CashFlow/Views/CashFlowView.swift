//
//  CashFlowView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 28/12/25.
//

import SwiftUI

struct CashFlowView: View {
    
    @State var cash:String = ""
    @State var description:String = ""
    @State var flowtype:MovementType = .out
    
    var body: some View {
        
        ZStack {
            
            Form {
                
                Section("Date") {
                    Text("\(Date().formatted(date: .abbreviated, time: .omitted))")
                }

                Section("Flow") {
                    
                    Picker("", selection: $flowtype) {
                        ForEach([MovementType.in, .out]) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }.pickerStyle(.segmented)
                }
                
                Section("Cash") {
                    TextField("0", text: $cash)
                        .keyboardType(.numberPad)
                }
                
                Section("Description") {
                    TextField("", text: $description, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                }
                
                
            }.navigationTitle("Cash Flow")
                .navigationBarTitleDisplayMode(.automatic)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Save") {
                            
                        }.fontWeight(.semibold)
                        .foregroundStyle(Color.textPrimary)
                    }
                }
            
        }
        
    }
}

#Preview {
    
    NavigationStack {
        CashFlowView()
    }
    
    
}
