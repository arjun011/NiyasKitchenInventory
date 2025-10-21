//
//  ReservationView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 20/09/25.
//

import SwiftUI

struct ReservationView: View {

    @State private var vm = BookingFormViewModel()

    var body: some View {

        ZStack{
            List {
                ForEach(vm.allBookings) { booking in
                    ReservationRowView(booking: booking).swipeActions {
                        
                        NavigationLink {
                            BookingFormView(isEdit: true, editBooking: booking)
                        } label: {
                            Image(systemName: "pencil")
                                .tint(Color.brandPrimary)
                               
                        }

                        Button {
                            Task {
                               await vm.deleteBooking(booking: booking)
                            }
                        } label: {
                            Image(systemName: "trash")
                                .tint(Color.red)
                        }
                    }
                    
                }
            }.blur(radius: vm.isLoading ? 1: 0)
            
            if vm.isLoading {
                ProgressView("Loading bookings...")
            }
            
        }.task {
            await vm.loadBookings()
        }.navigationTitle("Bookings")
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
