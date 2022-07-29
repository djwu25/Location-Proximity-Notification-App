//
//  MessagesView.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 7/29/22.
//

import SwiftUI
import Firebase

struct MessagesView: View {
    
    @ObservedObject var viewModel = MessageViewModel()
    let chatroom: Chatroom
    let currentUser = Auth.auth().currentUser
    
    @State var text = ""
    @FocusState private var isFocused
    
    @State private var messageIDToScroll: UUID?
    
    init(chatroom: Chatroom) {
        self.chatroom = chatroom
        viewModel.fetchData(docID: chatroom.id)
    }
    
    var body: some View {
        VStack {
            GeometryReader { reader in
                ScrollView {
                    VStack {
                        ForEach(viewModel.messages) { message in
                            HStack {
                                ZStack {
                                    Text(message.content)
                                        .padding(.horizontal)
                                        .padding(.vertical, 12)
                                        .background(Color.gray)
                                        .cornerRadius(25)
                                }
                                .frame(width: reader.size.width * 0.7, alignment: .leading)
                                .padding(.vertical, 2)
                                .padding(.leading, 5)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }
            
            toolBarView()
        }
        .padding(.top, 1)
        .toolbar() {
            ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                HStack{
                    Image(systemName: "person")
                    Text(chatroom.title)
                        .bold()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func toolBarView() -> some View {
        VStack{
            let height: CGFloat = 37
            HStack {
                TextField("Message ...", text: $text)
                    .padding(.horizontal, 10)
                    .frame(height: height)
                    .clipShape(RoundedRectangle(cornerRadius: 13))
                    .focused($isFocused)
                
                Button(action: sendMessage) {
                    Image(systemName: "arrow.up")
                        .foregroundColor(Color.white)
                        .frame(width: height, height: height)
                        .background(Circle().foregroundColor(text.isEmpty ? Color.gray : Color.blue))
                }
                .disabled(text.isEmpty)
            }
        }
        .padding(.horizontal)
        .padding(.vertical)
        .background(.thickMaterial)
    }
    
    func scrollTo(messageID: UUID, anchor: UnitPoint? = nil, shouldAnimate: Bool, scrollReader: ScrollViewProxy) {
        DispatchQueue.main.async {
            withAnimation(shouldAnimate ? Animation.easeIn : nil) {
                scrollReader.scrollTo(messageID, anchor: anchor)
            }
        }
    }
    
    func sendMessage() {
        viewModel.sendMessage(messageContent: text, docID: chatroom.id)
        text = ""
    }
    
    let columns = [GridItem(.flexible(minimum: 10))]
    
    /*
     for automatic scrolling
     .onChange(of: messageIDToScroll) { _ in
         if let messageIDToScroll = messageIDToScroll {
             scrollTo(messageID: messageIDToScroll, shouldAnimate: true, scrollReader: scrollReader)
         }
     }
     
     for cooler scroll view
     GeometryReader { reader in
         ScrollView {
             ScrollViewReader { scrollReader in
                 getMessagesView(viewWidth: reader.size.width)
                     .padding(.horizontal, 7)
             }
         }
     }
     
     FIX USER SEND MESSAGE ALIGNMENT AND BACKGROUND COLOR
     */
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView(chatroom: Chatroom(id: "101", title: "example", joinCode: 0))
    }
}
