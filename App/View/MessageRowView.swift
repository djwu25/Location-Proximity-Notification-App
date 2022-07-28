//
//  ChatRowView.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 7/4/22.
//

import SwiftUI

struct MessageRowView: View {
    
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

struct MessageRowView_Previews: PreviewProvider {
    static var previews: some View {
        MessageRowView(chat: Chatroom(id: "1", title: "Example", joinCode: 34))
    }
}
