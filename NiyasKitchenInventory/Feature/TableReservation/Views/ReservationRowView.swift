//
//  ReservationRowView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 21/09/25.
//

import SwiftUI
import Firebase

struct ReservationRowView: View {
    let booking: BookingModel

    
   
    var body: some View {
        
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(booking.name)
                    .font(.headline)
                
                if booking.isToday {
                    Text("Today")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(4)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(6)
                }
                
                Spacer()
                
                Text(booking.displaydateTime)
                .font(.subheadline)
            }

            Text("Guests: \(booking.guests)")
                .font(.subheadline)

            Text("Phone: \(booking.phoneNumber)")
                .font(.subheadline)

            if let note = booking.note, !note.isEmpty {
                Text("Note: \(note)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 6)
        
    }
}

#Preview {
    ReservationRowView(booking: BookingModel(name: "Arjun", phoneNumber: "0123123", guests: 11, dateTime: Date(), note: "sit inside", createdAt: Timestamp(date: Date()), bookedBy: "1234"))
}
