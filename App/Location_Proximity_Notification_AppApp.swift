//
//  Location_Proximity_Notification_AppApp.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 6/20/22.
//

import SwiftUI
import Firebase

@main
struct Location_Proximity_Notification_AppApp: App {
    @UIApplicationDelegateAdaptor(Delegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// Initialize Firebase
class Delegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
