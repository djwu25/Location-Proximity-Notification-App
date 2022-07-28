//
//  JoinOrCreateMessageView.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 7/27/22.
//

import SwiftUI

struct JoinOrCreateMessageView: View {
    
    @Binding var isOpen: Bool
    @StateObject var viewModel = ChatroomViewModel()
    @State var joinCode = ""
    @State var newTitle = ""
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Text("Join a Chatroom")
                        .font(.title)
                    TextField("Enter your join code", text: $joinCode)
                    Button(action: {
                        viewModel.joinChatroom(code: joinCode, handler: {self.isOpen = false})
                    }) {
                        Text("Join")
                    }
                }
                .padding()
                
                VStack {
                    Text("Create a Chatroom")
                        .font(.title)
                    TextField("Enter a Message Title", text: $newTitle)
                    Button(action: {
                        viewModel.createChatroom(title: newTitle, handler: {self.isOpen = false})
                    }) {
                        Text("Create")
                    }
                    .disabled(newTitle == "" ? true : false)
                }
                .padding()
            }
            .navigationBarTitle("Join or Create")
        }
    }
}

struct JoinOrCreateMessageView_Previews: PreviewProvider {
    static var previews: some View {
        JoinOrCreateMessageView(isOpen: .constant(true))
    }
}
