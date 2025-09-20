//
//  SettingsView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 19/09/25.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(AppSession.self) private var session
    
    var body: some View {

        Form {
            Section {

                NavigationLink {
                    AttendanceReportView()
                } label: {
                    Text("Attendance report")
                }

            } header: {
                Text("User")
            }
            
            Section {

                NavigationLink {
                    DailySalesView()
                } label: {
                    Text("Daily Sales")
                }

            } header: {
                Text("Sales")
            }

            Section {

                Button(role: .destructive) {
                    Task {

                        await session.signOut()

                    }
                } label: {
                    Text("Sign out")
                }

            }

        }

    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }

}
