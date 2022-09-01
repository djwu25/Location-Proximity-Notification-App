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
    
    init() {
        friendViewModel.fetchFriendData()
        friendViewModel.fetchFriendRequests()
    }
    
    var body: some View {
        VStack {
            Text("Friend Requests")
                .font(.title)
                .bold()
            List {
                ForEach(friendViewModel.friendRequests, id: \.self) { request in
                    HStack {
                        Text(request)
                            .padding(.trailing)
                            .lineLimit(1)
                        Button {
                            friendViewModel.makeFriend(request)
                        } label: {
                            Image(systemName: "checkmark")
                        }
                        Button {
                            friendViewModel.deleteFriendRequest(request)
                        } label: {
                            Text("X")
                        }
                        .padding(.leading)
                    }
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
