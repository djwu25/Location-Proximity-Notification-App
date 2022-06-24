//
//  WelcomeView.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 6/24/22.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        Text("Welcome to the Proximity App")
            .bold()
            .foregroundColor(Color.green)
            .font(.title)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
