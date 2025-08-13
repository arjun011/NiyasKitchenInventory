//
//  DashboardView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 12/08/25.
//

import SwiftUI

struct DashboardView: View {
    @Environment(AppSession.self) private var session
    var body: some View {
        VStack {
            Button("SignOut") {
                Task {
                    
                    await session.signOut()
                }
                
            }
        }
    }
}

#Preview {
    DashboardView()
}
