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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let last = locations.last
        
        let db = Firestore.firestore()
        
        db.collection("locations").document("sharing").setData(["updates" : [Auth.auth().currentUser?.email : GeoPoint(latitude: (last?.coordinate.latitude)!, longitude: (last?.coordinate.longitude)!)]], merge: true) { (err) in
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

class LocationObserver: ObservableObject {
    @Published var friendLocations = [String : GeoPoint]()
    @Published var annotations = [Place]()
    @Published var distances = [String : CLLocationDistance]()
    @Published var notClose = true
    
    private let locationManager = LocationManager()
    private let notificationManager = NotificationManager()
    private let tenMilesInMeters = CLLocationDistance(16093.5)
    let userEmail = Auth.auth().currentUser?.email
    
    init() {
        let db = Firestore.firestore()
        self.locationManager.checkIfLocationServicesIsEnabled()
        
        db.collection("locations").document("sharing").addSnapshotListener { (snap, err) in
            if err != nil {
                print((err?.localizedDescription)!)
            }
            
            let updates = snap?.get("updates") as! [String: GeoPoint]
            self.friendLocations = updates
            
            self.annotations.removeAll()
            for loc in self.friendLocations {
                if loc.key != self.userEmail {
                    self.annotations.append(Place(name: loc.key, coordinate: CLLocationCoordinate2D(latitude: loc.value.latitude, longitude: loc.value.longitude)))
                    self.distances[loc.key] = self.locationManager.locationManager?.location?.distance(from: CLLocation(latitude: loc.value.latitude, longitude: loc.value.longitude))
                }
            }
            
            for friend in self.distances {
                if friend.value < self.tenMilesInMeters && self.notClose {
                    print("Notification for Distance Triggered")
                    self.notificationManager.userClose = friend.key
                    self.notificationManager.displayNotification()
                    self.notClose = false
                }
            }
        }
    }
}
