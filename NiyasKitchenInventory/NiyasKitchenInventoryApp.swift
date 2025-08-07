//
//  NiyasKitchenInventoryApp.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 07/08/25.
//

import SwiftUI

@main
struct NiyasKitchenInventoryApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
