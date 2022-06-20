//
//  ContentView.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 6/20/22.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var notificationManager = NotificationManager()
    
    let newUser:User = User("Duke Wu")
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $locationManager.region, showsUserLocation: true)
                .ignoresSafeArea()
                .onAppear {
                    locationManager.checkIfLocationServicesIsEnabled()
                    notificationManager.requestNotificationAuthorization()
                }
            Button("Send Notification") {
                notificationManager.displayNotification()
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
