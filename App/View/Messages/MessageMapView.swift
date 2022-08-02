//
//  MessageMapView.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 8/1/22.
//

import SwiftUI
import MapKit

struct MessageMapView: View {
    var body: some View {
        VStack(alignment: .trailing) {
            /*
            Map(coordinateRegion: $locationManager.region, showsUserLocation: true, annotationItems: $locations.annotations) { place in
                MapAnnotation(coordinate: place.wrappedValue.coordinate) {
                    PlaceAnnotationView(title: place.name)
                }
            }
            .onAppear {
                locationManager.checkIfLocationServicesIsEnabled()
                locations.notClose = true
            }
            .edgesIgnoringSafeArea(.top)
             */
        }
    }
}

struct MessageMapView_Previews: PreviewProvider {
    static var previews: some View {
        MessageMapView()
    }
}
