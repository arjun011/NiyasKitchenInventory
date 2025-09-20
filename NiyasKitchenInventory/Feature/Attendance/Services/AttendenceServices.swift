//
//  AttendenceServices.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 19/09/25.
//

import Foundation
import Firebase
struct AttendenceServices: AttendenceServicesProtocol {
    
    var db:Firestore {
        Firestore.firestore()
    }
    
    
    
    func loadStaffList() async throws -> [UserProfile] {
        
        let snapshot = try await db.collection("users").getDocuments()
        
        var staffList:[UserProfile] = []
        for doc in snapshot.documents {
            let docId = doc.documentID
            var user = try doc.data(as: UserProfile.self)
            user.uid = docId
            staffList.append(user)
        }
        
        return staffList
        
    }
    
    func loadAttendance(startDate: Date, endDate: Date, selectedUserId: String) async throws -> [AttendanceRecord] {
        var newRecords: [AttendanceRecord] = []
        let db = Firestore.firestore()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        try await withThrowingTaskGroup(of: AttendanceRecord?.self) { group in
            var date = startDate

            while date <= endDate {
                let currentDate = date
                let datePath = formatter.string(from: currentDate)

                group.addTask {
                    let snapshot = try await db
                        .collection("users")
                        .document(selectedUserId)
                        .collection("attendance")
                        .document(datePath)
                        .collection("punches")
                        .order(by: "timestamp")
                        .getDocuments()

                    let punchTimes = snapshot.documents
                        .compactMap { $0.data()["timestamp"] as? Timestamp }
                        .map { $0.dateValue() }

                    if punchTimes.count >= 2 {
                        let duration = punchTimes.last!.timeIntervalSince(punchTimes.first!)
                        return AttendanceRecord(date: currentDate, status: .present, duration: duration)
                    } else if punchTimes.count == 1 {
                        return AttendanceRecord(date: currentDate, status: .missedPunchOut, duration: nil)
                    }

                    return nil
                }

                date = Calendar.current.date(byAdding: .day, value: 1, to: date) ?? date
            }

            for try await record in group {
                if let record = record {
                    newRecords.append(record)
                }
            }
        }

        return newRecords.sorted(by: { $0.date > $1.date })
    }
    
}
