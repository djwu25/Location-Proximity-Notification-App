//
//  FullListFriendView.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 8/3/22.
//

import SwiftUI
import Firebase

struct FullListFriendView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var friendViewModel = FriendViewModel()
    var currentUserEmail = Auth.auth().currentUser?.email
    @State var sendingFriendRequest = false;
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(0..<10) { num in
                    Text(currentUserEmail!)
                }
            }
            .navigationTitle("Friends")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        sendingFriendRequest.toggle()
                    } label: {
                        Text("Friend Requests")
                    }
                }
            }
            .sheet(isPresented: $sendingFriendRequest) {
                FriendRequestView()
            }
        }
    }
}

struct FullListFriendView_Previews: PreviewProvider {
    static var previews: some View {
        FullListFriendView()
    }
}
