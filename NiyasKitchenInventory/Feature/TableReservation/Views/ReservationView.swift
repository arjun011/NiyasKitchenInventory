//
//  ReservationView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 20/09/25.
//

import SwiftUI

struct ReservationView: View {
    var body: some View {
        
        VStack {
            Text("Hello, World!")
        }.navigationTitle("Reservation")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        BookingFormView()
                    } label: {
                        Image(systemName: "plus.circle")
                            .tint(Color.brandPrimary)
                    }

                }
            }
        
        
    }
}

#Preview {
    NavigationStack {
        ReservationView()
    }
    
}
