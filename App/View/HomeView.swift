//
//  HomeView.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 6/21/22.
//

import SwiftUI
import Firebase
import simd
import BackgroundTasks

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(configuration.isPressed ? Color.green.opacity(0.5) : Color.green)
            .foregroundColor(Color.white)
            .clipShape(Capsule())
    }
}

struct HomeView: View {
    @StateObject private var notificationManager = NotificationManager()
    @StateObject private var locObserver = LocationObserver()
    @State private var showMap = false
    @AppStorage("status") var logged = false
    
    var body: some View {
        TabView {
            WelcomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            MapView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
        .onAppear {
            notificationManager.requestNotificationAuthorization()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
