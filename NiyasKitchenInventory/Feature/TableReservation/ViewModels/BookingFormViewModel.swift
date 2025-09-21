//
//  BookingFormViewModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 20/09/25.
//

import Firebase
import FirebaseFirestore
import Foundation

@MainActor
@Observable final class BookingFormViewModel {

    var name: String = ""
    var phoneNumber: String = ""
    var numberOfGuests: Int = 2
    var date: Date = Date()
    var note: String = ""

    var isSubmitting = false
    var submissionSuccess = false
    var submissionError: String?
    var isLoading: Bool = false

    var todayBookingCount: Int = 0
    var nextBookingDateText: String? = nil
    var allBookings: [BookingModel] = []

    var isFormValid: Bool {
        !name.isEmpty && !phoneNumber.isEmpty
    }

    private var services = BookingServices()

    func submitBooking(by userId: String) async {
        isSubmitting = true
        submissionSuccess = false
        submissionError = nil

        do {
            let db = Firestore.firestore()
            let newBooking = BookingModel(
                name: name,
                phoneNumber: phoneNumber,
                guests: numberOfGuests,
                dateTime: date,
                note: note,
                createdAt: Timestamp(date: Date()),
                bookedBy: userId
            )

            let docRef = db.collection("bookings").document()
            try docRef.setData(from: newBooking, merge: false)

            //            try await docRef.updateData([
            //                "createdAt": FieldValue.serverTimestamp()
            //            ])
            //
            //            _ = try db.collection("bookings").addDocument(from: newBooking)
            submissionSuccess = true

            // Reset form after success

            name = ""
            phoneNumber = ""
            numberOfGuests = 2
            date = Date()
            note = ""
            print("Booking succesfull")
        } catch {
            submissionError = error.localizedDescription
            print("Booking failed = \(error)")
        }

        isSubmitting = false
    }

    func loadBookings() async {

        do {
            self.allBookings = try await services.loadBookings()
            print("All booking count = \(self.allBookings.count)")
            self.todayBookingCount =
                self.allBookings.filter {
                    Calendar.current.isDateInToday($0.dateTime)
                }.count

            if todayBookingCount == 0, let next = self.allBookings.first {
                let df = DateFormatter()
                df.dateStyle = .medium
                df.timeStyle = .short
                self.nextBookingDateText = df.string(from: next.dateTime)
            }
        } catch {
            print("Failed to load bookings: \(error.localizedDescription)")
        }

    }
}
