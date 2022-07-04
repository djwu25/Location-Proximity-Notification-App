//
//  ChatRowView.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 7/4/22.
//

import SwiftUI

struct MessageRowView: View {
    
    let chat: Chat
    
    var body: some View {
        HStack {
            Image(systemName: "person")
                .resizable()
                .frame(width: 70, height: 70)
            
            ZStack {
                VStack(alignment: .leading, spacing: 5) {
                    HStack{
                        Text(chat.person.name)
                            .bold()
                        
                        Spacer()
                        
                        Text(chat.messages.last?.date.descriptiveString() ?? "")
                    }
                    
                    HStack{
                        Text(chat.messages.last?.text ?? "")
                            .foregroundColor(Color.gray)
                            .lineLimit(2)
                            .frame(height: 50, alignment: .top)
                            .padding(.trailing, 40)
                    }
                }
                
                Circle()
                    .foregroundColor(chat.hasUnreadMessage ? .blue : .clear)
                    .frame(width: 18, height: 18)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                 
            }
        }
        .frame(height: 80)
    }
}

struct MessageRowView_Previews: PreviewProvider {
    static var previews: some View {
        MessageRowView(chat: Chat.sampleChats[2])
    }
}
