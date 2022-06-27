//
//  HomeView.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 6/21/22.
//

import SwiftUI
import Firebase
import simd
import BackgroundTasks

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(configuration.isPressed ? Color.green.opacity(0.5) : Color.green)
            .foregroundColor(Color.white)
            .clipShape(Capsule())
    }
}

struct HomeView: View {
    
    // FOR HOME VIEW
    
    @StateObject private var notificationManager = NotificationManager()
    @StateObject private var locObserver = LocationObserver()
    @State private var showMap = false
    @AppStorage("status") var logged = false
    
    // FOR ANIMATION
    
    @State var animationValues: [Bool] = Array(repeating: false, count: 10)
    
    var body: some View {
        ZStack {
            
            // HOME VIEW
            
            TabView {
                WelcomeView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                MapView()
                    .tabItem {
                        Image(systemName: "map")
                        Text("Map")
                    }
                ProfileView()
                    .tabItem {
                        Image(systemName: "person")
                        Text("Profile")
                    }
            }
            .opacity(animationValues[6] ? 1 : 0)
            
            // SPLASH SCREEN
            
            if !animationValues[5] {
                VStack {
                    ZStack {
                        RoundedRectangle(cornerSize: CGSize(width: 15, height: 15))
                            .stroke(.green, lineWidth: 20)
                            .frame(width: 175, height: 175)
                            .scaleEffect(animationValues[0] ? 1 : 0, anchor: .center)
                            .rotationEffect(.init(degrees: 45))
                        
                        Image(systemName: "arrowtriangle.right.fill")
                            .resizable()
                            .foregroundColor(.green)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .scaleEffect(animationValues[0] ? 1 : 0, anchor: .center)
                            .offset(x:10)
                            
                    }
                    .scaleEffect(animationValues[1] ? 0.75 : 1)
                    .padding(.horizontal, 60)
                    .padding(.vertical, 60)
                    .drawingGroup()
                    .rotationEffect(Angle.degrees(animationValues[3] ? 270 : 0))
                    .offset(y:animationValues[4] ? -450 : 0)
                    
                    Text("Proximity")
                        .font(.title.bold())
                        .foregroundColor(.green)
                        .opacity(animationValues[2] ? 1 : 0)
                        .offset(y: animationValues[2] ? -35 : 0)
                        .offset(y: animationValues[4] ? 400 : 0)
                }
                .offset(y: -50)
                .environment(\.colorScheme, .dark)
            }
        }
        .onAppear {
            notificationManager.requestNotificationAuthorization()
            
            // ANIMATION
            withAnimation(.easeInOut(duration: 0.3)) {
                animationValues[0] = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                
                animationValues[1] = true
                
                withAnimation(.easeInOut(duration: 0.3)) {
                     animationValues[2] = true
                }
                
                withAnimation(.easeInOut(duration: 1).delay(0.3)) {
                     animationValues[3] = true
                }
                
                withAnimation(.easeInOut(duration: 0.8).delay(1.5)) {
                    animationValues[4] = true
                }
                
                withAnimation(.easeIn(duration: 0.5).delay(2)) {
                    animationValues[6] = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    animationValues[5] = true
                    
                    
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
