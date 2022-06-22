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
        VStack {
            Text("User: \(Auth.auth().currentUser?.email ?? "")")
                .padding()
            Text("ID:   \(Auth.auth().currentUser?.uid ?? "")")
                .padding()
            Button("Go to Map", action: showOnMap)
                .buttonStyle(PrimaryButtonStyle())
            Button("Send Notification", action: sendNotification)
                .buttonStyle(PrimaryButtonStyle())
            Button("Sign Out", action: signOut)
                .buttonStyle(PrimaryButtonStyle())
        }
        .padding()
        .onAppear {
            notificationManager.requestNotificationAuthorization()
        }
        .sheet(isPresented: $showMap) {
            MapView()
        }
    }
    
    func showOnMap() {
        showMap = true
    }
    
    func sendNotification() {
        notificationManager.displayNotification()
    }
    
    func signOut() {
        try? Auth.auth().signOut()
        
        self.logged = false
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
