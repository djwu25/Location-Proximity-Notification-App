//
//  ChatroomRowView.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 7/29/22.
//

import SwiftUI

struct ChatroomRowView: View {
    
    let chat: Chatroom
    
    var body: some View {
        HStack {
            Image(systemName: "person")
                .resizable()
                .frame(width: 70, height: 70)
            
            ZStack {
                VStack(alignment: .leading, spacing: 5) {
                    HStack{
                        Text(chat.title)
                            .bold()
                        
                        Spacer()
                    }
                }
                 
            }
        }
        .frame(height: 80)
    }
}

struct ChatroomRowView_Previews: PreviewProvider {
    static var previews: some View {
        ChatroomRowView(chat: Chatroom(id: "1", title: "Example", joinCode: 34))
    }
}

