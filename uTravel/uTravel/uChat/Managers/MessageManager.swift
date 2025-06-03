//
//  MessageManager.swift
//  uTravel
//
//  Created by James Flair on 4/29/25.
//
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

public final class MessageManager {
    static let shared = MessageManager()
    private let db = Firestore.firestore()

    func fetchMessages(for chatId: String, completion: @escaping (Result<[Message], Error>) -> Void) -> ListenerRegistration? {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "MessageManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "No authenticated user"])))
            return nil
        }
        return db.collection("Users")
            .document(userId)
            .collection("uChat")
            .document(chatId)
            .collection("Messages")
            .order(by: "createdAt", descending: false)
            .addSnapshotListener { snapshot, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    let messages = snapshot?.documents.compactMap { document in
                        try? document.data(as: Message.self)
                    } ?? []
                    
                    completion(.success(messages))
                }
        }
        
        func sendMessage(_ message: Message, completion: @escaping (Result<Void, Error>) -> Void) {
            guard let userId = Auth.auth().currentUser?.uid else {
                completion(.failure(NSError(domain: "MessageManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "No authenticated user"])))
                return
            }
            do {
                try db.collection("Users")
                    .document(userId)
                    .collection("uChat")
                    .document(message.chatId)
                    .collection("Messages")
                    .document(message.id)
                    .setData(from: message)
                
                db.collection("uChat")
                    .document(message.chatId)
                    .updateData(["lastMessage": message.text,
                        "lastMessageTimestamp": message.createdAt])
                
                let otherUserId = message.chatId
                
                try db.collection("Users")
                    .document(otherUserId)
                    .collection("uChat")
                    .document(userId) //  current userId becomes the chatId for the other user
                    .collection("Messages")
                    .document(message.id)
                    .setData(from: message)
                
                let chatUpdate = [
                    "lastMessage": message.text,
                    "lastMessageTimestamp": message.createdAt
                ] as [String: Any]
                
                db.collection("Users")
                    .document(userId)
                    .collection("uChat")
                    .document(message.chatId)
                    .updateData(chatUpdate) { _ in }
                
                db.collection("Users")
                    .document(otherUserId)
                    .collection("uChat")
                    .document(userId)
                    .updateData(chatUpdate)
                
                { error in
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            completion(.success(()))
                        }
                    }
            } catch {
                completion(.failure(error))
            }
    }
}

