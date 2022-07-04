//
//  ChatView.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 7/4/22.
//

import SwiftUI

struct ChatView: View {
    
    @EnvironmentObject var viewModel: MessageViewModel
    
    let chat: Chat
    
    @State var text = ""
    @FocusState private var isFocused
    
    @State private var messageIDToScroll: UUID?
    
    var body: some View {
        VStack {
            GeometryReader { reader in
                ScrollView {
                    ScrollViewReader { scrollReader in
                        getMessagesView(viewWidth: reader.size.width)
                            .padding(.horizontal, 7)
                            .onChange(of: messageIDToScroll) { _ in
                                if let messageIDToScroll = messageIDToScroll {
                                    scrollTo(messageID: messageIDToScroll, shouldAnimate: true, scrollReader: scrollReader)
                                }
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
                    Text(chat.person.name)
                        .bold()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.markAsRead(false, chat: chat)
        }
    }
    
    func toolBarView() -> some View {
        VStack{
            let height: CGFloat = 37
            HStack {
                TextField("Message ...", text: $text)
                    .padding(.horizontal, 10)
                    .frame(height: height)
                    .foregroundColor(Color.black.opacity(0.8))
                    .background(Color.white)
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
        if let message = viewModel.sendMessage(text, in: chat) {
            text = ""
            messageIDToScroll = message.id
        }
    }
    
    let columns = [GridItem(.flexible(minimum: 10))]
    
    func getMessagesView(viewWidth: CGFloat) -> some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(chat.messages) { message in
                let isReceived = message.type == .Received
                HStack {
                    ZStack {
                        Text(message.text)
                            .padding(.horizontal)
                            .padding(.vertical, 12)
                            .background(isReceived ? Color.gray : Color.blue)
                            .cornerRadius(25)
                    }
                    .frame(width: viewWidth * 0.7, alignment: isReceived ? .leading : .trailing)
                    .padding(.vertical, 5)
                }
                .frame(maxWidth: .infinity, alignment: isReceived ? .leading : .trailing)
                .id(message.id)
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(chat: Chat.sampleChats[2])
            .environmentObject(MessageViewModel())
    }
}
