//
//  DashboardViewModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 31/08/25.
//

import Foundation

@MainActor @Observable final class DashboardViewModel {

    var totalInventoryCount: Int = 0
    var lowStockInventoryCount: Int = 0
    var staleInventoryCount: Int = 0
    var wasteLastSevenDayCount: Int = 0

    private let inventoryServices = InventoryListServices()
    private let movementServices = MovementsServices()

    // Punch-In, Punch-out
    var punchList: [PunchModel] = []
    var statusMessage: String = ""
    var showIrregularPopup: Bool = false

    var isPunchInEnabled: Bool = true
    var isPunchOutEnabled: Bool = false

    private let repo = DashboardServices()

    // Booking reservation
    var bookingCount: Int = 0
    var bookingTitle: String = "No Bookings"
    var selectedDate: Date? = nil
    var showBookingsList: Bool = false

    private var bookingServices = BookingServices()

    func getInventoryList() async {

        do {

            let inventoryList = try await inventoryServices.fetchInventory()
            self.updateDashBoard(inventoryList: inventoryList)
        } catch {
            print(error.localizedDescription)
        }

    }

    private func updateDashBoard(inventoryList: [InventoryItemModel]) {

        self.totalInventoryCount = inventoryList.count
        self.lowStockInventoryCount =
            inventoryList.filter { $0.isLowStock }.count

        let sevenDaysAgo = Calendar.current.date(
            byAdding: .day, value: -7, to: Date())!
        self.staleInventoryCount =
            inventoryList.filter { $0.updatedAt < sevenDaysAgo }.count

    }

    func getWasteCount() async {

        let sevenDaysAgo = Calendar.current.date(
            byAdding: .day, value: -7, to: Date())!
        do {

            let wastCount = try await movementServices.countWastMovementsSince(
                sevenDaysAgo)
            print("Waste Count = \(wastCount)")
            self.wasteLastSevenDayCount = wastCount

        } catch {
            print("Waste error")
            print(error.localizedDescription)
        }
    }
}



//MARK: - Punch In/ Punch out -
extension DashboardViewModel {

    func loadPunches(for date: Date = Date(), userId: String) async {
        do {
            punchList = try await repo.getPunches(userId: userId, date: date)
            updateButtonState()
        } catch {
            statusMessage =
                "Error loading punches: \(error.localizedDescription)"
        }
    }

    func checkPunchStateOnAppOpen(userId: String) async {

        await loadPunches(userId: userId)

        if let yesterday = Date.yesterday,
            let last = try? await lastPunch(for: yesterday, userId: userId),
            last.type == .in
        {
            // Apply auto punch-out
            let autoOutTime = Calendar.current.date(
                bySettingHour: 22, minute: 30, second: 0, of: yesterday)!
            try? await repo.addPunch(
                userId: userId, timestamp: autoOutTime, type: .out,
                isAutoOut: true, isIrregular: true)

            statusMessage =
                "⚠️ Missed Punch-Out yesterday. Auto Punch-Out applied."
            showIrregularPopup = true
        }

        // Check if yesterday ended with unclosed .in

    }

    func punchNow(userId: String) async {
        let typeToPunch = punchList.last?.type == .in ? PunchType.out : .in
        do {
            try await repo.addPunch(
                userId: userId, timestamp: Date(), type: typeToPunch)
            await loadPunches(userId: userId)
            statusMessage =
                "Punched \(typeToPunch.rawValue.capitalized) at \(formatTime(Date()))"
        } catch {
            statusMessage = "Punch failed: \(error.localizedDescription)"
        }
    }

    private func updateButtonState() {
        guard let last = punchList.last else {
            isPunchInEnabled = true
            isPunchOutEnabled = false
            return
        }

        if last.type == .in {
            isPunchInEnabled = false
            isPunchOutEnabled = true
        } else {
            isPunchInEnabled = true
            isPunchOutEnabled = false
        }
    }

    private func lastPunch(for day: Date, userId: String) async throws
        -> PunchModel?
    {
        let punches = try await repo.getPunches(userId: userId, date: day)
        return punches.last
    }

    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

}

//MARK: - Booking reservation -
extension DashboardViewModel {

    func loadBookings() async {
        do {
            let bookings = try await bookingServices.loadBookings()

            let today = Calendar.current.startOfDay(for: Date())
            let todayBookings = bookings.filter {
                Calendar.current.isDate($0.dateTime, inSameDayAs: today)
            }

            if !todayBookings.isEmpty {
                self.bookingCount = todayBookings.count
                self.bookingTitle = "Today's Bookings"
                self.selectedDate = today
            } else {
                // Find next upcoming date
                if let nextBooking =
                    bookings
                    .sorted(by: { $0.dateTime < $1.dateTime })
                    .first(where: { $0.dateTime > today })
                {

                    self.bookingCount = 0
                    self.bookingTitle =
                        "Next Booking on \(nextBooking.dateTime.formatted(date: .abbreviated, time: .omitted))"
                    self.selectedDate = nextBooking.dateTime
                } else {
                    self.bookingTitle = "No Upcoming Bookings"
                    self.bookingCount = 0
                }
            }

        } catch {
            print("Failed to fetch bookings: \(error)")
        }
    }
}
