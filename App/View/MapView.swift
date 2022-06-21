//
//  MapView.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 6/21/22.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var locationManager = LocationManager()
    @Environment(\.dismiss) private var dismiss
    
    let newUser:User = User("Duke Wu")
    
    var body: some View {
        VStack(alignment: .leading) {
            Button("< Back to Home") {
                dismiss()
            }
            .padding()
            Map(coordinateRegion: $locationManager.region, showsUserLocation: true)
                .onAppear {
                    locationManager.checkIfLocationServicesIsEnabled()
                }
        }
        
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
