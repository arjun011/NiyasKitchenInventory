//
//  SettingsView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 19/09/25.
//

import SwiftUI

struct SettingsView: View {
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

        }
        
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
    
}
