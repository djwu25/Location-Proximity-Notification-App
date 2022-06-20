//
//  User.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 6/20/22.
//

import Foundation
import CoreLocation

class User {
    private var friends:[User]
    private var name:String
    
    
    init(_ name:String) {
        self.name = name
        friends = []
    }
    
    func addFriend(_ newFriend:User) {
        friends.append(newFriend)
    }
    
    func getFriends() -> [User] {
        return friends
    }
    
    func setName(_ name:String) {
        self.name = name
    }
    
    func getName() -> String {
        return name
    }
}

