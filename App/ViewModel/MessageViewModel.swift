//
//  MessageViewModel.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 7/4/22.
//

import Foundation
import Firebase

struct Message: Codable, Identifiable {
    var id: String?
    var content: String
    var name: String
}

class MessageViewModel: ObservableObject {
    @Published var messages = [Message]()
    @Published var users = [String]()
    private let db = Firestore.firestore()
    private let user = Auth.auth().currentUser
    
    func sendMessage(messageContent: String, docID: String) {
        if user != nil {
            db.collection("chatrooms").document(docID).collection("messages").addDocument(data: [
                "sentAt": Date(),
                "displayName": user!.displayName!,
                "content": messageContent,
                "sender": user!.displayName!])
        }
    }
    
    func fetchData(docID: String) {
        if user != nil {
            db.collection("chatrooms").document(docID).collection("messages").order(by: "sentAt", descending: false).addSnapshotListener( { (snapshot, error) in
                guard let documents = snapshot?.documents else {
                    print("no documents")
                    return
                }
                
                self.messages = documents.map { docSnapshot -> Message in
                    let data = docSnapshot.data()
                    let docId = docSnapshot.documentID
                    let content = data["content"] as? String ?? ""
                    let displayName = data["displayName"] as? String ?? ""
                    return Message(id: docId, content: content, name: displayName)
                }
            })
        }
    }
    
    func fetchUsers(docID: String) {
        if user != nil {
            db.collection("chatrooms").document(docID).getDocument( completion: { (snapshot, error) in
                guard let data = snapshot?.data() else {
                    print("no document found")
                    return
                }
                
                self.users = data["users"] as? [String] ?? []
            })
        }
    }
}
