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
    var isEdit:Bool = false
    var editBooking:BookingModel?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Reservation Details")) {
                    TextField("Name", text: $vm.name)
                    TextField("Phone Number", text: $vm.phoneNumber)
                        .keyboardType(.phonePad)

                    HStack(alignment: .center) {
                        Text("Number of Guests:")
                        TextField("00", text: $vm.numberOfGuests)
                            .keyboardType(.numberPad)
                            .padding(.horizontal)
                    }

                    DatePicker("Date & Time", selection: $vm.date, in: Date()..., displayedComponents: [.date, .hourAndMinute])

                    TextField("Special Request / Note", text: $vm.note, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                    
                }.onTapGesture {
                    hideKeyboard()
                }

                Section {
                    Button {
                        Task {
                            if isEdit {
                                await vm.updateBooking(by: session.profile?.uid ?? "", bookigId: editBooking?.id)
                            }else {
                                await vm.submitBooking(by: session.profile?.uid ?? "")
                            }
                            
                        }
                    } label: {
                        HStack {
                            if vm.isSubmitting {
                                ProgressView()
                            }
                            isEdit ? Text("Update Booking") :  Text("Confirm Booking")
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
            .navigationTitle(isEdit ? "Update a Table" : "Book a Table")
        }.onAppear {
            if isEdit {
                vm.fillForm(for: self.editBooking)
            }
        }
    }

}

#Preview {
    BookingFormView()
        .environment(AppSession())
}
