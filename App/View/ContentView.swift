//
//  ContentView.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 6/20/22.
//

import SwiftUI
import MapKit
import Firebase
import CoreLocation

struct ContentView: View {
    @AppStorage("status") var logged = false
    
    var body: some View {
        if logged {
            HomeView()
        } else {
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
