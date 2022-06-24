//
//  ProfileView.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 6/24/22.
//

import SwiftUI
import Firebase

struct ProfileView: View {
    @AppStorage("status") var logged = false
    
    var body: some View {
        VStack {
            Text("Email: \(Auth.auth().currentUser?.email ?? "")")
                .padding()
            Text("ID:   \(Auth.auth().currentUser?.uid ?? "")")
                .padding()
            Button("Sign Out", action: signOut)
                .buttonStyle(PrimaryButtonStyle())
        }
        .padding()
    }
    
    func signOut() {
        try? Auth.auth().signOut()
        
        self.logged = false
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
