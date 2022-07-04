//
//  MessageModel.swift
//  Location Proximity Notification App
//
//  Created by Duke Wu on 7/4/22.
//

import Foundation

struct Chat: Identifiable {
    var id: UUID {person.id}
    let person: Person
    var messages: [Message]
    var hasUnreadMessage: Bool = false
}

struct Person: Identifiable {
    let id = UUID()
    let name: String
}

struct Message: Identifiable {
    enum MessageType {
        case Sent, Received
    }
    let id = UUID()
    let date: Date
    let text: String
    let type: MessageType
    
    init(_ text: String, type: MessageType, date: Date) {
        self.text = text
        self.type = type
        self.date = date
    }
    
    init(_ text: String, type: MessageType) {
        self.init(text, type: type, date: Date())
    }
}

extension Chat {
    
    static let sampleChats = [
        Chat(person: Person(name: "Duke"), messages: [
            Message("Hey!", type: .Sent, date: Date(timeIntervalSinceNow: -180*60)),
            Message("Sup!", type: .Received, date: Date(timeIntervalSinceNow: -179*60))], hasUnreadMessage: true),
        Chat(person: Person(name: "Kaylin"), messages: [
            Message("Hey!", type: .Sent, date: Date(timeIntervalSinceNow: -180*60)),
            Message("Sup!", type: .Received, date: Date(timeIntervalSinceNow: -179*60))], hasUnreadMessage: false),
        Chat(person: Person(name: "Mom"), messages: [
            Message("Hey!", type: .Sent, date: Date(timeIntervalSinceNow: -4100*60)),
            Message("How's it been? It's been so long since we last sent messages to each other! Hope you have been doing well all this time", type: .Received,
                    date: Date(timeIntervalSinceNow: -4000*60)),
            Message("I've been good! It's been great here in San Diego", type: .Sent, date: Date(timeIntervalSinceNow: -3900*60)),
            Message("That's great! Mom and Dad are also doing great at home! Hope to keep in touch further throughout the school year", type: .Received,
                    date: Date(timeIntervalSinceNow: -3850*60))], hasUnreadMessage: false)
    ]
    
}
