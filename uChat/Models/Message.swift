//
//  Messages.swift
//  uTravel
//
//  Created by James Flair on 4/28/25.
//


import Foundation
import FirebaseAuth
import FirebaseFirestore



struct Message: Codable, Identifiable, Equatable, Hashable {
    let id: String
    let chatId: String
    let senderId: String
    let senderName: String
    let text: String
    let photoURL: String?
    let createdAt: Date
    
    init(id: String = UUID().uuidString,
         chatId: String,
         senderId: String,
         senderName: String,
         text: String,
         photoURL: String? = nil,
         createdAt: Date = Date()) {
        self.id = id
        self.chatId = chatId
        self.senderId = senderId
        self.senderName = senderName
        self.text = text
        self.photoURL = photoURL
        self.createdAt = createdAt
    }
    
    func isFromCurrentUser() -> Bool {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return false
        }
        return currentUserId == senderId
    }
    
    func fetchPhotoURL() -> URL? {
        guard let photoURLString = photoURL, let url = URL(string: photoURLString) else {
            return nil
        }
        return url
    }
}
