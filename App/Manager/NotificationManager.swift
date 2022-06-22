//
//  NotificationManager.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 6/20/22.
//

import Foundation
import UserNotifications
import Firebase
import CoreLocation

class NotificationManager: ObservableObject {
    var userClose:String = ""
    
    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {
            success, error in
            if success {
                print("Success")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func displayNotification() {
        let content = UNMutableNotificationContent()
        content.title = "\(userClose) IS NEARBY"
        content.subtitle = "\(userClose) is within 10 miles of your location"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        print("Notification has been sent")
    }
}
