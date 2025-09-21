//
//  BookingFormView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 20/09/25.
//

import SwiftUI


struct BookingFormView: View {
    @Environment(AppSession.self) private var session
    @State private var vm = BookingFormViewModel()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Reservation Details")) {
                    TextField("Name", text: $vm.name)
                    TextField("Phone Number", text: $vm.phoneNumber)
                        .keyboardType(.phonePad)

                    Stepper(value: $vm.numberOfGuests, in: 1...30) {
                        Text("Number of Guests: \(vm.numberOfGuests)")
                    }

                    DatePicker("Date & Time", selection: $vm.date, in: Date()..., displayedComponents: [.date, .hourAndMinute])

                    TextField("Special Request / Note", text: $vm.note, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                    
                    
                }

                Section {
                    Button {
                        Task {
                            await vm.submitBooking(by: session.profile?.uid ?? "")
                        }
                    } label: {
                        HStack {
                            if vm.isSubmitting {
                                ProgressView()
                            }
                            Text("Confirm Booking")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .disabled(!vm.isFormValid || vm.isSubmitting)
                }

                if vm.submissionSuccess {
                    Section {
                        Label("Booking saved!", systemImage: "checkmark.circle")
                            .foregroundColor(.green)
                    }
                }

                if let error = vm.submissionError {
                    Section {
                        Label("Error: \(error)", systemImage: "xmark.octagon")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Book a Table")
        }
    }

}

#Preview {
    BookingFormView()
        .environment(AppSession())
}
