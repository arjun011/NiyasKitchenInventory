//
//  SettingsView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 19/09/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(AppSession.self) private var session
    @AppStorage("biometricLockEnabled") private var biometricLockEnabled = false
    @State private var punchNotifications = true
    @State private var maxWorkingHours: Double = 10
    @State private var autoExportEnabled = false

    @State private var showAccessManagement = false
    @State private var showShiftSettings = false
    @State private var showCategoryManager = false
    @State private var showSupplierManager = false

    var body: some View {

        Form {

            Section {
                Text("Name: \(session.profile?.displayName ?? "Unknown")")
                Text("Role: \(session.profile?.role ?? "N/A")")
                Text("Email: \(session.profile?.email ?? "N/A")")
                
                NavigationLink {
                    AttendanceReportView()
                } label: {
                    Text("My Attendence")
                }
                
                Toggle(
                    "Face ID",
                    isOn: $biometricLockEnabled)
                
                
                
                Button(role: .destructive) {
                    Task {
                        await session.signOut()
                    }
                } label: {
                    Text("Log Out")
                }

            } header: {
                Text("Profile")
            }

            Section {
                Toggle("Notifications", isOn: $punchNotifications)
            } header: {
                Text("Notifications")
            }

            Section {

                NavigationLink {
                    CategoryManagementView()
                } label: {
                    Text("Category Manager")
                }

                NavigationLink {
                    SupplierManagementView()
                } label: {
                    Text("Supplier Manager")
                }
                
                NavigationLink {
                    CashFlowReportView()
                } label: {
                    Text("CashFlow")
                }

            } header: {
                Text("Management")
            }
            Section("App Info & Support") {
                Text("Version: 1.2.3")
                Link(
                    "Contact Developer",
                    destination: URL(string: "https://wa.me/447442646021")!)
            }

        }
        .navigationTitle("Settings")

    }
}

// Dummy views for navigation (replace with actual implementations)

struct CategoryManagementView: View {
    var body: some View {
        Text("Category Management")
    }
}

struct SupplierManagementView: View {
    var body: some View {
        Text("Supplier Management")
    }
}

#Preview {
    NavigationStack {
        SettingsView().environment(AppSession())
    }

}
