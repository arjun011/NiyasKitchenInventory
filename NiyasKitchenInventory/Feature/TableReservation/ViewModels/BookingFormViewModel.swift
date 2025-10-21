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
    var numberOfGuests = "2"
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
            let newBooking = BookingModel(
                name: name,
                phoneNumber: phoneNumber,
                guests: Int(numberOfGuests) ?? 2,
                dateTime: date,
                note: note,
                createdAt: Timestamp(date: Date()),
                bookedBy: userId
            )
            
            try await services.saveBooking(newBooking: newBooking)
            submissionSuccess = true

            // Reset form after success

            name = ""
            phoneNumber = ""
            numberOfGuests = "2"
            date = Date()
            note = ""
            print("Booking succesfull")
        } catch {
            submissionError = error.localizedDescription
            print("Booking failed = \(error)")
        }

        isSubmitting = false
    }
    
    func updateBooking(by userId: String, bookigId: String?) async {
        isSubmitting = true
        submissionSuccess = false
        submissionError = nil
    
        do {
            var newBooking = BookingModel(
                name: name,
                phoneNumber: phoneNumber,
                guests: Int(numberOfGuests) ?? 2,
                dateTime: date,
                note: note,
                createdAt: Timestamp(date: Date()),
                bookedBy: userId
            )
            
            newBooking.id = bookigId ?? ""
            
            try await services.updateBooking(booking: newBooking)
            submissionSuccess = true

            // Reset form after success

            name = ""
            phoneNumber = ""
            numberOfGuests = "2"
            date = Date()
            note = ""
            print("Booking succesfull")
        } catch {
            submissionError = error.localizedDescription
            print("Booking failed = \(error)")
        }

        isSubmitting = false
    }
    
    func deleteBooking(booking: BookingModel) async {
        do {
            try await services.deleteBooking(booking: booking)
            let index = self.allBookings.firstIndex(where: { $0.id == booking.id })!
            self.allBookings.remove(at: index)
            
            print("Deleted booking with id: \(booking.id ?? "Error")")
        } catch {
            print("Failed to delete booking with id: \(booking.id ?? "Error")")
        }
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
    
    func fillForm(for booking: BookingModel?) {
        self.name = booking?.name ?? ""
        self.phoneNumber = booking?.phoneNumber ?? ""
        self.date = booking?.dateTime ?? Date()
        self.numberOfGuests = "\(booking?.guests ?? 1)"
        self.note = booking?.note ?? ""
    }
}
