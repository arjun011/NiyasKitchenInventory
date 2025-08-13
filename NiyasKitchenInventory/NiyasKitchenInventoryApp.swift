//
//  NiyasKitchenInventoryApp.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 07/08/25.
//

import FirebaseCore
import SwiftUI
import FirebaseAppCheck

@main
struct NiyasKitchenInventoryApp: App {

    private var session = AppSession()
    init() {
        FirebaseApp.configure()

        #if DEBUG
            let providerFactory = AppCheckDebugProviderFactory()
            AppCheck.setAppCheckProviderFactory(providerFactory)
        #endif
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(session)
                .task {
                     session.start()
                }
        }
    }
}
