//
//  MessageMapView.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 8/1/22.
//

import SwiftUI
import MapKit

struct MessageMapView: View {
    // Map Location Manager & Observer
    @ObservedObject var locationObserver: MessageLocationObserver
    @StateObject var locationManager: MessageLocationManager
    
    var body: some View {
        VStack(alignment: .trailing) {
            Map(coordinateRegion: $locationManager.region, showsUserLocation: true, annotationItems: $locationObserver.annotations) { place in
                MapAnnotation(coordinate: place.wrappedValue.coordinate) {
                    PlaceAnnotationView(title: place.name)
                }
            }
            .onAppear {
                locationManager.checkIfLocationServicesIsEnabled()
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct MessageMapView_Previews: PreviewProvider {
    static var previews: some View {
        MessageMapView(locationObserver: MessageLocationObserver(docID: "0"), locationManager: MessageLocationManager(docID: "0"))
    }
}
