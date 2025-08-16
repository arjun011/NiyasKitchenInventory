//
//  PillButtonView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 16/08/25.
//

import SwiftUI

struct PillButtonView: View {
    
    var title:String
    
    var body: some View {
        
        Button {
            
        } label: {
            
            Text(title)
                .foregroundStyle(Color.white)
                .font(.system(size: 16, weight: .semibold))
                //.padding(10)
                
            
        }.buttonBorderShape(.capsule)
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .tint(Color.brandPrimary)

    }
}

#Preview {
    PillButtonView(title: "Stock In")
}
