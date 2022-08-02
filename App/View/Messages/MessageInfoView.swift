//
//  MessageInfoView.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 8/1/22.
//

import SwiftUI
import Firebase

struct MessageInfoView: View {
    
    @ObservedObject var viewModel = MessageViewModel()
    
    init(docID: String) {
        viewModel.fetchUsers(docID: docID)
    }
    
    var body: some View {
        VStack {
            Text("Members")
                .font(.title)
                .bold()
                .padding()
            List(viewModel.users, id: \.self) { user in
                Text(user)
            }
            Button(action: showGroupChatUserLocations) {
                HStack{
                    Image(systemName: "map")
                    Text("Map")
                }
            }
            .padding()
        }
    }
    
    func showGroupChatUserLocations() {
        
    }
}

struct MessageInfoView_Previews: PreviewProvider {
    static var previews: some View {
        MessageInfoView(docID: "0")
    }
}
