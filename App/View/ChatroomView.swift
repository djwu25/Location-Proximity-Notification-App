//
//  ChatroomView.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 7/29/22.
//

import SwiftUI

struct ChatroomView: View {
    @ObservedObject var viewModel = ChatroomViewModel()
    
    @State private var query = ""
    @State var joinModal = false
    
    init() {
        viewModel.fetchData()
    }
    
    var body: some View {
        NavigationView {
            List(viewModel.chatrooms) { chatroom in
                NavigationLink(destination: MessagesView(chatroom: chatroom)) {
                    ZStack {
                        ChatroomRowView(chat: chatroom)
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button(action: {
                            viewModel.deleteChatroom(chat: chatroom)
                        }) {
                            Label("Delete", systemImage: "minus.circle")
                        }.tint(.red)
                    }
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

struct ChatroomView_Previews: PreviewProvider {
    static var previews: some View {
        ChatroomView()
    }
}
