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
    @Published var friendRequests = [String]()
    private let user = Auth.auth().currentUser
    private let db = Firestore.firestore()
    
    func fetchFriendData() {
        if user != nil {
            db.collection("users").document(user?.email as? String ?? "").addSnapshotListener( { (snapshot, error) in
                guard let data = snapshot?.data() else {
                    print("no data returned")
                    return
                }
                
                self.friends = data["friends"] as? [String] ?? []
            })
        }
    }
    
    func sendFriendRequest(_ friendUserEmail: String) {
        if user != nil {
            db.collection("users").document(friendUserEmail.lowercased()).getDocument(completion: { (document, error) in
                if document?.exists ?? false {
                    // Doc exists
                    if friendUserEmail.lowercased() == self.user?.email {
                        print("Can't send friend request to self")
                        return
                    }
                    
                    self.db.collection("users").document(friendUserEmail)
                        .updateData(["friend_requests" : FieldValue.arrayUnion([self.user?.email as? String ?? ""])])
                    return
                } else {
                    // Doc doesn't exist
                    // Create Alert of User Doesn't Exist
                    print("Friend Email Not Found")
                    return
                }
            })
        }
    }
    
    func fetchFriendRequests() {
        if user != nil {
            db.collection("users").document(self.user?.email as? String ?? "").addSnapshotListener( { (snapshot, error) in
                guard let data = snapshot?.data() else {
                    print("no data returned")
                    return
                }
                
                self.friendRequests = data["friend_requests"] as? [String] ?? []
            })
        }
    }
    
    func makeFriend(_ friendEmail: String) {
        if user != nil {
            print("Making Friends")
            
            db.collection("users").document(user?.email as? String ?? "").getDocument( completion: { (document, error) in
                if document?.exists ?? false {
                    // Doc exists
                    self.db.collection("users").document(self.user?.email as? String ?? "")
                        .updateData(["friends" : FieldValue.arrayUnion([friendEmail])])
                    return
                } else {
                    // Doc doesn't exist
                    // Should Never Run
                    print("Friend Email Not Found")
                    return
                }
            })
            
            db.collection("users").document(friendEmail).getDocument(completion: { (document, error) in
                if document?.exists ?? false {
                    // Doc exists
                    self.db.collection("users").document(friendEmail)
                        .updateData(["friends" : FieldValue.arrayUnion([self.user?.email as? String ?? ""])])
                    return
                } else {
                    // Doc doesn't exists
                    // Should Never Run
                    print("Friend Email Not Found")
                    return
                }
            })
            
            deleteFriendRequest(friendEmail)
            // Need to also remove friend request from other friend if it exists
        }
    }
    
    func deleteFriendRequest(_ friendReqeustEmail: String) {
        if user != nil {
            db.collection("users").document(user?.email as? String ?? "").getDocument( completion: { (document, error) in
                if document?.exists ?? false {
                    // Doc exists
                    self.db.collection("users").document(self.user?.email as? String ?? "")
                        .updateData(["friend_requests" : FieldValue.arrayRemove([friendReqeustEmail])])
                    return
                } else {
                    // Doc doesn't exist
                    // Create Alert of User Doesn't Exist
                    print("Friend Email Not Found")
                    return
                }
            })
        }
    }
}
