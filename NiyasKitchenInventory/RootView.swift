//
//  RootView.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 12/08/25.
//

import SwiftUI

struct RootView: View {
    
    @Environment(AppSession.self) private var session
    
    var body: some View {
        Group {
            if session.isLoading {
                // simple splash/loading
                ZStack {
                    Color(.brandPrimary).ignoresSafeArea()
                    ProgressView().tint(.white)
                }
            } else if session.isAuthenticated {
                TabShellView()  // your main app shell
            } else {
                LoginView()  // your finished login screen
            }
        }
    }
}

#Preview {
    RootView()
}
