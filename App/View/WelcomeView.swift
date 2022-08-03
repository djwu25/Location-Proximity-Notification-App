//
//  WelcomeView.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 6/24/22.
//

import SwiftUI

struct WelcomeView: View {
    
    @State var friendView = false
    
    var body: some View {
        VStack {
            Text("Welcome to the Proximity App")
                .bold()
                .foregroundColor(Color.green)
                .font(.title)
            Spacer()
            Button(action: {friendView.toggle()}) {
                Text("Friends")
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .sheet(isPresented: $friendView) {
            FullListFriendView()
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
