//
//  NiyasKitchenInventoryApp.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 07/08/25.
//

import FirebaseCore
import SwiftUI
import FirebaseAppCheck

//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(
//        _ application: UIApplication,
//        didFinishLaunchingWithOptions launchOptions: [UIApplication
//            .LaunchOptionsKey: Any]? = nil
//    ) -> Bool {
//        FirebaseApp.configure()
//        return true
//    }
//}

@main
struct NiyasKitchenInventoryApp: App {

    init() {
        FirebaseApp.configure()

        #if DEBUG
            let providerFactory = AppCheckDebugProviderFactory()
            AppCheck.setAppCheckProviderFactory(providerFactory)
        #endif
    }

    // register app delegete with Firebase setup
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LoginView()
                .environment(
                    \.managedObjectContext,
                    persistenceController.container.viewContext)
        }
    }
}
