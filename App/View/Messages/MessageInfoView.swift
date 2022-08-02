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
    let locationManager: MessageLocationManager
    let locationObserver: MessageLocationObserver
    
    init(docID: String, locationManager: MessageLocationManager, locationObserver: MessageLocationObserver) {
        self.locationManager = locationManager
        self.locationObserver = locationObserver
        viewModel.fetchUsers(docID: docID)
        viewModel.fetchTitle(docID: docID)
        viewModel.fetchJoinCode(docID: docID)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text(viewModel.title)
                    .font(.title)
                    .bold()
                    .padding(.bottom)
                Text("Members")
                    .font(.title3)
                    .bold()
                    .padding()
                List(viewModel.users, id: \.self) { user in
                    Text(user)
                }
                Text(verbatim: "Join Code: \(viewModel.joinCode)")
                .padding()
                NavigationLink(destination: MessageMapView(locationObserver: locationObserver, locationManager: locationManager)) {
                    HStack{
                        Image(systemName: "map")
                        Text("Map")
                    }
                }
                .padding()
            }
        }
    }
}

struct MessageInfoView_Previews: PreviewProvider {
    static var previews: some View {
        MessageInfoView(docID: "0", locationManager: MessageLocationManager(docID: "0"), locationObserver: MessageLocationObserver(docID: "0"))
    }
}
