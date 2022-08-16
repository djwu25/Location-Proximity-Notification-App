//
//  FriendRequestView.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 8/15/22.
//

import SwiftUI

struct FriendRequestView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var friendViewModel = FriendViewModel()
    @State var friendEmail = ""
    
    var body: some View {
        VStack {
            Text("Friend Requests")
                .font(.title)
                .bold()
            List {
                ForEach(0..<10) { num in
                    Text("Test")
                }
            }
            TextField("Friend's Email", text: $friendEmail)
                .textFieldStyle(PrimaryTextFieldStyle())
            Button {
                friendViewModel.sendFriendRequest(friendEmail)
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Send Friend Request")
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .padding()
    }
}

struct FriendRequestView_Previews: PreviewProvider {
    static var previews: some View {
        FriendRequestView()
    }
}
