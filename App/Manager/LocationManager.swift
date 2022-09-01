//
//  LocationManager.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 6/20/22.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:32.8801, longitude: -117.2340), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    var currentUser = Auth.auth().currentUser
    var locationManager:CLLocationManager?
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager!.startUpdatingLocation()
        } else {
            print("Missing Location Services. Need to turn on.")
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestAlwaysAuthorization()
                break
            case .restricted:
                print("Need to unrestrict lcoations alert")
                break
            case .denied:
                print("Need permissions alert")
                break
            case .authorizedAlways, .authorizedWhenInUse:
                if(locationManager.location == nil) {
                    return
                }
                region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
                break
            @unknown default:
                break
            }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if currentUser == nil  {
            return
        }
        
        let last = locations.last
        
        if last == nil || last?.coordinate.latitude == nil || last?.coordinate.longitude == nil || currentUser?.displayName == nil {
            return
        }
        
        let db = Firestore.firestore()
        
        db.collection("locations").document("sharing").setData(["updates" : [currentUser?.displayName ?? "" : GeoPoint(latitude: (last?.coordinate.latitude)!, longitude: (last?.coordinate.longitude)!)]], merge: true) { (err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
        }
    }
}

struct Place: Identifiable {
  let id = UUID()
  var name: String
  var coordinate: CLLocationCoordinate2D
}
