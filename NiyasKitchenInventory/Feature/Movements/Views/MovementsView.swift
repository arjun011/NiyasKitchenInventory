//
//  MovementsView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 28/08/25.
//

import SwiftUI

struct MovementsView: View {
    var body: some View {
       
        VStack {
        
        }.navigationTitle("Movements")
        .navigationBarTitleDisplayMode(.automatic)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "Plus.fill")
                        .tint(Color.brandPrimary)
                }

            }
        }
        
    }
}

#Preview {
    NavigationStack {
        MovementsView()
    }
    
}
