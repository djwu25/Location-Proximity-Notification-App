//
//  LocationManager.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 6/20/22.
//

import UIKit
import MapKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:32.8801, longitude: -117.2340), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    var locationManager:CLLocationManager?
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
        } else {
            print("Missing Location Services. Need to turn on.")
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestAlwaysAuthorization()
            case .restricted:
                print("Need to unrestrict lcoations alert")
            case .denied:
                print("Need permissions alert")
            case .authorizedAlways, .authorizedWhenInUse:
                region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            @unknown default:
                break
            }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
