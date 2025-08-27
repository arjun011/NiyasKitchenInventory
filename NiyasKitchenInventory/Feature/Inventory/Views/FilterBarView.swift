//
//  FilterBarView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 18/08/25.
//

import SwiftUI

struct FilterBarView: View {

    @Binding var suppliers:[String]
    @Binding var selectedSupplier: (String?, Bool)
    @Binding var showLowStockOnly: Bool
    @Binding var sortedByNewToOld: Bool
    @Binding var showStaleOnly: Bool
    
    var body: some View {

        ScrollView(.horizontal, showsIndicators: false) {

            HStack(
                alignment: .center, spacing: 8,
                content: {

                    // Supplier
                    
                    Menu {
                        Button("All Suppliers") {
                            selectedSupplier = (nil, false)
                        }

                        ForEach(suppliers, id: \.self) { supplier in
                            Button {
                                self.selectedSupplier = (supplier, true)
                            } label: {
                                Text("\(supplier)")
                            }
                        }
                    } label: {
                        
                        FilterToggleLabelView(icon:"person.2.fill" , title: "\(selectedSupplier.0 ?? "Supplier")", isOn: $selectedSupplier.1)
                    }

                    // Low Cost
                    
                    Button {
                        self.showLowStockOnly.toggle()
                    } label: {
                        
                        FilterToggleLabelView(icon: "exclamationmark.triangle.fill" , title: "Low Stock", isOn: $showLowStockOnly)
                    }
 
                    // Stale toggle
                    
                    Button {
                        self.showStaleOnly.toggle()
                    } label: {
                        FilterToggleLabelView(icon: "clock.fill" , title: "Stale (>7d)", isOn: $showStaleOnly)
                    }

                    // Sortby New -> Old
                    Button {
                        self.sortedByNewToOld.toggle()
                    } label: {
                        
                        FilterToggleLabelView(icon: "exclamationmark.triangle.fill" , title: "Last Updated (new → old)", isOn: $sortedByNewToOld)
                    }
                }).padding(.vertical, 8)
            
        }
    }
}



#Preview {
    
    @Previewable @State var suppliers:[String] = Array(
        Set(
            mockInventory.map({
                $0.supplierName
            })))
    @Previewable @State var selectedSupplier: (String?, Bool) = (nil, false)
    @Previewable @State var showLowStockOnly: Bool = false
    @Previewable @State var sortedByNewToOld: Bool = false
    @Previewable @State var showStaleOnly: Bool = false
    
    FilterBarView(suppliers: $suppliers, selectedSupplier: $selectedSupplier, showLowStockOnly: $showLowStockOnly, sortedByNewToOld: $sortedByNewToOld, showStaleOnly: $showStaleOnly)
}
