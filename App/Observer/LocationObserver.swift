//
//  LocationObserver.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 8/2/22.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class LocationObserver: ObservableObject {
    @Published var friendLocations = [String : GeoPoint]()
    @Published var annotations = [Place]()
    @Published var distances = [String : CLLocationDistance]()
    @Published var notClose = false
    
    private let locationManager = LocationManager()
    private let notificationManager = NotificationManager()
    private let tenMilesInMeters = CLLocationDistance(16093.5)
    let displayName = Auth.auth().currentUser?.displayName ?? ""
    
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
                if loc.key != self.displayName {
                    self.annotations.append(Place(name: loc.key, coordinate: CLLocationCoordinate2D(latitude: loc.value.latitude, longitude: loc.value.longitude)))
                    self.distances[loc.key] = self.locationManager.locationManager?.location?.distance(from: CLLocation(latitude: loc.value.latitude, longitude: loc.value.longitude))
                }
            }
            
            for friend in self.distances {
                if friend.value < self.tenMilesInMeters && self.notClose {
                    print("Notification for Distance Triggered for \(friend.key)")
                    self.notificationManager.userClose = friend.key
                    self.notificationManager.displayNotification()
                }
            }
            self.notClose = false
        }
    }
}
