//
//  FriendViewModel.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 8/3/22.
//

import Foundation
import Firebase

class FriendViewModel: ObservableObject {
    @Published var friends = [String]()
    private let user = Auth.auth().currentUser
    private let db = Firestore.firestore()
    
    func fetchFriendData() {
        if user != nil {
            db.collection("user_friends").document(user?.email as? String ?? "").addSnapshotListener( { (snapshot, error) in
                guard let data = snapshot?.data() else {
                    print("no data returned")
                    return
                }
                
                self.friends = data["friends"] as? [String] ?? []
            })
        }
    }
    
    func sendFriendRequest(_ friendUserEmail: String) {
        
    }
}
