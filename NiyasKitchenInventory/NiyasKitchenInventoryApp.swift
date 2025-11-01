//
//  NiyasKitchenInventoryApp.swift
//  NiyasKitchenInventory
//
//  Created by Arjun on 07/08/25.
//

import FirebaseAppCheck
import FirebaseCore
import FirebaseMessaging
import SwiftUI

@main
struct NiyasKitchenInventoryApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    private var session = AppSession()
    init() {

        FirebaseApp.configure()

        #if DEBUG
            AppCheck.setAppCheckProviderFactory(AppCheckDebugProviderFactory())
        #endif


    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(.light)
                .environment(session)
                .task {
                    session.start()
                }
        }
    }
}

//MARK: - AppDelegate -

final class AppDelegate: NSObject, UIApplicationDelegate, @MainActor UNUserNotificationCenterDelegate, @MainActor MessagingDelegate {
    
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    UNUserNotificationCenter.current().delegate = self
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
      print("Notifications permission granted: \(granted)")
    }
    application.registerForRemoteNotifications()

    Messaging.messaging().delegate = self
    return true
  }

  // APNs token -> Firebase
  func application(_ application: UIApplication,
                   didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
  }

  // FCM token (send this to your backend or save in Firestore per user)
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("FCM token: \(fcmToken ?? "nil")")
      
      Messaging.messaging().subscribe(toTopic: "closing-sales") { error in
          if let error = error {
              print("Topic subscribe failed: \(error)")
          } else {
              print("Subscribed to closing-sales")
          }
      }
      
    // TODO: store token under user doc, e.g. /users/{uid}/fcmTokens/{token}
  }

  // Foreground notifications
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.banner, .sound, .badge])
  }
}

