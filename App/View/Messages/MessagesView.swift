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
    let currentUserName = Auth.auth().currentUser?.displayName as? String ?? ""
    
    @State var text = ""
    @FocusState private var isFocused
    
    @State private var messageIDToScroll: UUID?
    
    @State var messageInfoSheet = false;
    
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
                                        .background(currentUserName == message.name ? Color.blue : Color.gray)
                                        .cornerRadius(25)
                                }
                                .frame(width: reader.size.width * 0.7, alignment: currentUserName == message.name ? .trailing : .leading)
                                .padding(.vertical, 2)
                                .padding(.horizontal, 5)
                            }
                            .frame(maxWidth: .infinity, alignment: currentUserName == message.name ? .trailing : .leading)
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
            
            ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                Button(action: {messageInfoSheet.toggle()}) {
                    Image(systemName: "info.circle")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $messageInfoSheet) {
            MessageInfoView(docID: chatroom.id)
        }
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
    
    func messageInfo() {
        
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
     */
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView(chatroom: Chatroom(id: "101", title: "example", joinCode: 0))
    }
}
