//
//  MapView.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 6/21/22.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var notificationManager = NotificationManager()
    @StateObject private var locationManager = LocationManager()
    @StateObject var locations = LocationObserver()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .trailing) {
            Button(action: {dismiss()}, label: {
                Text("X")
                    .foregroundColor(Color.green)
                    .font(.title2)
            })
            .padding()
            Map(coordinateRegion: $locationManager.region, showsUserLocation: true, annotationItems: $locations.annotations) { place in
                MapAnnotation(coordinate: place.wrappedValue.coordinate) {
                    PlaceAnnotationView(title: place.name)
                }
            }
            .onAppear {
                locationManager.checkIfLocationServicesIsEnabled()
                locations.notClose = true
            }
            .ignoresSafeArea()
        }

    }
}

struct PlaceAnnotationView: View {
    @Binding var title: String
    @State private var showTitle:Bool = true

    var body: some View {
        VStack(spacing: 0) {
          Text(title)
            .font(.callout)
            .padding(5)
            .background(Color(.white))
            .foregroundColor(Color.black)
            .cornerRadius(10)
            .opacity(showTitle ? 1 : 0)
          
          Image(systemName: "mappin.circle.fill")
            .font(.title2)
            .foregroundColor(.red)
        }
        .onTapGesture {
            withAnimation(.easeOut) {
                showTitle.toggle()
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
