//
//  AttendanceReportViewModel.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 19/09/25.
//

import Foundation

@MainActor
@Observable final class AttendanceReportViewModel {

    private let services: AttendenceServicesProtocol

    init(services: AttendenceServicesProtocol = AttendenceServices()) {
        self.services = services
    }

    var startDate: Date =
        Calendar.current.date(byAdding: .day, value: -6, to: Date()) ?? Date()
    var endDate: Date = Date()
    var showDatePicker = false
    var selectedStaffId: String? = nil
    var staffList: [UserProfile] = []
    var attendanceRecords: [AttendanceRecord] = []
    var currentUserRole: String = "Employee"

    var totalHours: String {
        let totalSeconds = attendanceRecords.compactMap { $0.duration }.reduce(
            0, +)
        let hours = Int(totalSeconds) / 3600
        let minutes = (Int(totalSeconds) % 3600) / 60
        return "\(hours)h \(minutes)m"
    }

    func formattedRange(_ start: Date, _ end: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return
            "\(formatter.string(from: start)) - \(formatter.string(from: end))"
    }

    func loadCurrentUser(currentUser: UserProfile) async {

        self.currentUserRole = currentUser.role

        do {

            if currentUserRole == "Employee" {
                self.selectedStaffId = currentUser.uid
                self.attendanceRecords =  try await services.loadAttendance(startDate: startDate, endDate: endDate, selectedUserId: currentUser.uid ?? "")
            } else {
                 await self.loadStaffList()
            }

        } catch {
            print(error)
        }

    }
    
    
    func loadAttendance() async {
        
        do {
            self.attendanceRecords =  try await services.loadAttendance(startDate: startDate, endDate: endDate, selectedUserId: selectedStaffId ?? "")
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func loadStaffList() async {
        do {
            self.staffList = try await services.loadStaffList()
            self.selectedStaffId = self.staffList.first?.uid
            await loadAttendance()
        }catch {
            print(error)
        }
    }

}
