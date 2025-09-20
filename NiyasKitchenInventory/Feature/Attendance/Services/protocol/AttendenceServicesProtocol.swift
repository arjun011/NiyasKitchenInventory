//
//  AttendenceServicesProtocol.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 19/09/25.
//

import Foundation

protocol AttendenceServicesProtocol:Sendable {
    
    func loadStaffList() async throws -> [UserProfile]
    
    func loadAttendance(startDate: Date, endDate: Date, selectedUserId: String) async throws -> [AttendanceRecord]
}
