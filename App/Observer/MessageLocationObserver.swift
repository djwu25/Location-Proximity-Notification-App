//
//  MessageLocationObserver.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 8/2/22.
//

import UIKit
import MapKit
import CoreLocation
import Firebase


class MessageLocationObserver: ObservableObject {
    @Published var annotations = [Place]()
    
    var friendLocations = [String : GeoPoint]()
    var distances = [String : CLLocationDistance]()
    let displayName = Auth.auth().currentUser?.displayName ?? ""
    let db = Firestore.firestore()
    
    init(docID: String) {
        db.collection("chatrooms").document(docID).collection("user_locations").document("shared_locations").addSnapshotListener( { (snapshot, error) in
            if error != nil {
                print((error?.localizedDescription)!)
            }

            let updates = snapshot?.get("updates") as! [String: GeoPoint]
            self.friendLocations = updates

            self.annotations.removeAll()
            for location in self.friendLocations {
                if location.key != self.displayName {
                    self.annotations.append(Place(name: location.key, coordinate: CLLocationCoordinate2D(latitude: location.value.latitude, longitude: location.value.longitude)))
                }
            }
        })
    }
}
