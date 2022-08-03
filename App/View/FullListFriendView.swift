//
//  FullListFriendView.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 8/3/22.
//

import SwiftUI
import Firebase

struct FullListFriendView: View {
    
    @ObservedObject var friendViewModel = FriendViewModel()
    var currentUserEmail = Auth.auth().currentUser?.email
    
    var body: some View {
        Text(currentUserEmail!)
        List {
            
        }
        Button(action: {}) {
            
        }
    }
}

struct FullListFriendView_Previews: PreviewProvider {
    static var previews: some View {
        FullListFriendView()
    }
}
