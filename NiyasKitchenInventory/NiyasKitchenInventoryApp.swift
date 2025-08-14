//
//  NiyasKitchenInventoryApp.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 07/08/25.
//

import FirebaseAppCheck
import FirebaseCore
import SwiftUI

@main
struct NiyasKitchenInventoryApp: App {

    private var session = AppSession()
    init() {

        FirebaseApp.configure()

        #if DEBUG
            AppCheck.setAppCheckProviderFactory(AppCheckDebugProviderFactory())
        #endif

//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = UIColor(named: "BrandNavy")
//        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
//        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
//
//        UINavigationBar.appearance().standardAppearance = appearance
//        UINavigationBar.appearance().scrollEdgeAppearance = appearance
//        UINavigationBar.appearance().compactAppearance = appearance

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
