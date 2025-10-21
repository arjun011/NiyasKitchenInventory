//
//  BookingServices.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 20/09/25.
//

import Firebase
import Foundation

struct BookingServices: Sendable {

    private var db: Firestore { Firestore.firestore() }

    func loadBookings() async throws -> [BookingModel] {

        let today = Calendar.current.startOfDay(for: Date())

        let snapshot = try await db.collection("bookings")
            .whereField(
                "dateTime", isGreaterThanOrEqualTo: Timestamp(date: today)
            )
            .order(by: "dateTime")
            .getDocuments()

        let bookings = try snapshot.documents.compactMap {
            try $0.data(as: BookingModel.self)
        }

        return bookings

    }
    
    func saveBooking(newBooking:BookingModel) async throws  {
        
            let db = Firestore.firestore()
            let docRef = db.collection("bookings").document()
            try docRef.setData(from: newBooking, merge: false)
    }
    
    func updateBooking(booking: BookingModel) async throws {
        
        let docRef = db.collection("bookings").document(booking.id ?? "")
        
        // Convert model to [String: Any] dictionary
        let data = try Firestore.Encoder().encode(booking)
        // Update Firestore document
        try await docRef.updateData(data)
        
    }
    
    func deleteBooking(booking: BookingModel) async throws {
        
        let docRef = db.collection("bookings").document(booking.id ?? "")
        try await docRef.delete()
    }
}
