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
}
