//
//  ContentView.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 6/20/22.
//

import SwiftUI
import MapKit
import Firebase

struct ContentView: View {
    @State var signedIn:Bool = false
    
    var body: some View {
        if signedIn {
            HomeView(signedIn: $signedIn)
        } else {
            LoginView(signedIn: $signedIn)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
