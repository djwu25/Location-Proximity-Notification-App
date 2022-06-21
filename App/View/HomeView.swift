//
//  HomeView.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 6/21/22.
//

import SwiftUI
import Firebase
import simd

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
    @State private var showMap = false
    @Binding var signedIn:Bool
    
    var body: some View {
        VStack {
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
        
        self.signedIn = false
    }
}

struct HomeView_Previews: PreviewProvider {
    @State static var signedIn:Bool = false
    
    static var previews: some View {
        HomeView(signedIn: $signedIn)
    }
}
