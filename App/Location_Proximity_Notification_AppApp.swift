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
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
