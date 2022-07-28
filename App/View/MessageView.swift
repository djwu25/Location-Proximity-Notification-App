//
//  MessageView.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 7/4/22.
//

import SwiftUI

struct MessageView: View {
    
    @StateObject var viewModel = MessageViewModel()
    @ObservedObject var viewModelTwo = ChatroomViewModel()
    
    @State private var query = ""
    @State var joinModal = false
    
    init() {
        viewModelTwo.fetchData()
    }
    
    var body: some View {
        NavigationView {
            List(viewModelTwo.chatrooms) { chatroom in
                HStack {
                    Text(chatroom.title)
                    Spacer()
                }
            }
            .listStyle(PlainListStyle())
            .searchable(text: $query)
            .navigationTitle("Messages")
            .toolbar() {
                Button(action: {
                    self.joinModal = true
                }) {
                    Image(systemName: "square.and.pencil")
                }
            }
        }
        .sheet(isPresented: $joinModal, content: {
            JoinOrCreateMessageView(isOpen: $joinModal)
        })
    }
    
    /* ForEach(viewModel.getSortedFilteredMessages(query: query)) { chat in
        ZStack {
            MessageRowView(chat: chat)
            
            NavigationLink (destination: {
                ChatView(chat: chat)
                    .environmentObject(viewModel)
            }) {
                EmptyView()
            }
            .buttonStyle(PlainButtonStyle())
            .frame(width: 0)
            .opacity(0)
        }
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button(action: {
                viewModel.markAsRead(!chat.hasUnreadMessage, chat: chat)
            }) {
                if chat.hasUnreadMessage {
                    Label("Read", systemImage: "text.bubble")
                } else {
                    Label("Unread", systemImage: "circle.fill")
                }
            }
            .tint(.blue)
        }
    } */
    
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView()
    }
}
