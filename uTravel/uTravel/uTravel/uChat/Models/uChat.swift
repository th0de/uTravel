//
//  uChat.swift
//  uTravel
//
//  Created by James Flair on 5/30/25.
//

import Foundation
import FirebaseFirestore

struct uChat: Codable, Identifiable {
    let id: String
    let participants: [String]
    let participantNames: [String: String]
    let lastMessage: String?
    let lastMessageTimestamp: Date
    let createdAt: Date
    
    init(id: String = UUID().uuidString,
         participants: [String],
         participantNames: [String: String],
         lastMessage: String? = nil,
         lastMessageTimestamp: Date = Date(),
         createdAt: Date = Date()) {
        self.id = id
        self.participants = participants.sorted()
        self.participantNames = participantNames
        self.lastMessage = lastMessage
        self.lastMessageTimestamp = lastMessageTimestamp
        self.createdAt = createdAt
    }
}
