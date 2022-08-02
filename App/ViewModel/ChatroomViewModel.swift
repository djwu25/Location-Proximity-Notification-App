//
//  ChatroomViewModel.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 7/27/22.
//

import Foundation
import Firebase

struct Chatroom: Codable, Identifiable {
    var id: String
    var title: String
    var joinCode: Int
}

class ChatroomViewModel: ObservableObject {
    @Published var chatrooms = [Chatroom]()
    private var db = Firestore.firestore()
    private var user = Auth.auth().currentUser
    
    func fetchData() {
        if user != nil {
            db.collection("chatrooms").whereField("users", arrayContains: user!.displayName!).addSnapshotListener( { (snapshot, error) in
                guard let documents = snapshot?.documents else {
                    print("no docs returned")
                    return
                }
                
                self.chatrooms = documents.map({ docSnapshot -> Chatroom in
                    let data = docSnapshot.data()
                    let docId = docSnapshot.documentID
                    let title = data["title"] as? String ?? ""
                    let joinCode = data["joinCode"] as? Int ?? -1
                    return Chatroom(id: docId, title: title, joinCode: joinCode)
                })
            })
        }
    }
    
    func createChatroom(title: String, handler: @escaping () -> Void) {
        if user != nil {
            db.collection("chatrooms").addDocument(data: [
                "title": title,
                "joinCode": Int.random(in: 0..<99999),
                "users": [user!.displayName!]]) { err in
                    if let err = err {
                        print("error adding document! \(err)")
                    } else {
                        handler()
                    }
            }
        }
    }
    
    func joinChatroom(code: String, handler: @escaping () -> Void) {
        if user != nil {
            db.collection("chatrooms").whereField("joinCode", isEqualTo: Int(code) as Any).getDocuments() { (snapshot, error) in
                if let error = error {
                    print("error getting documents! \(error)")
                } else {
                    for document in snapshot!.documents {
                        self.db.collection("chatrooms").document(document.documentID).updateData(["users": FieldValue.arrayUnion([self.user!.displayName!])])
                        handler()
                    }
                }
            }
        }
    }
    
    func removeUserFromChatroom(chat: Chatroom) {
        if user != nil {
            db.collection("chatrooms").whereField("joinCode", isEqualTo: Int(chat.joinCode) as Any).getDocuments() { (snapshot, error) in
                if let error = error {
                    print("error getting documents to delete! \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("no document found")
                    return
                }
                
                for document in documents {
                    let data = document.data()
                    let users = data["users"] as? [String] ?? []
                    
                    if users.capacity == 1 {
                        self.db.collection("chatrooms").document(document.documentID).delete()
                    } else {
                        self.db.collection("chatrooms").document(document.documentID).updateData(["users": FieldValue.arrayRemove([self.user!.displayName!])])
                    }
                }
            }
        }
    }
}
