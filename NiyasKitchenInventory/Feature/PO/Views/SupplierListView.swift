//
//  SupplierListView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 02/09/25.
//

import SwiftUI

struct SupplierListView: View {
    
    @Environment(\.dismiss) var dismiss
    var supplierList:[SupplierModel]
    var selectedSupplier:(SupplierModel) -> Void
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            List(supplierList) { supplier in
                
                Button {
                    selectedSupplier(supplier)
                    dismiss()
                } label: {
                    Text(supplier.name)
                        .foregroundStyle(.black)
                }.frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
        }
        
        
    }
}

#Preview {
    SupplierListView(supplierList: mockSuppliersSeed) { supplier in
        print(supplier.name)
    }
}
