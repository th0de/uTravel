//
//  ChatManager.swift
//  uTravel
//
//  Created by James Flair on 5/27/25.
//

import FirebaseAuth
import FirebaseFirestore

class ChatManager {
    static let shared = ChatManager()
    private let db = Firestore.firestore()
    
    func createOrGetChat(with otherUserId: String, otherUserName: String, completion: @escaping (Result<uChat, Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "ChatManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "No current user"])))
            return
        }
        
        let participants = [currentUser.uid, otherUserId].sorted()
        let participantNames = [
            currentUser.uid: currentUser.displayName ?? "Unknown",
            otherUserId: otherUserName
        ]
        

        db.collection("Users")
            .document(currentUser.uid)
            .collection("uChat")
            .document(otherUserId)
            .getDocument { [weak self] DocumentSnapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let document = DocumentSnapshot, document.exists {

                    do {
                        let chat = try document.data(as: uChat.self)
                        completion(.success(chat))
                    } catch {
                        completion(.failure(error))
                    }
                    return
                }
                
         
                let newChat = uChat(
                    id: otherUserId, // use other userId as chatId
                    participants: participants,
                    participantNames: participantNames
                )
                
                let batch = self?.db.batch()

                let currentUserChatRef = self?.db.collection("Users")
                    .document(currentUser.uid)
                    .collection("uChat")
                    .document(otherUserId)
                

                let otherUserChatRef = self?.db.collection("Users")
                    .document(otherUserId)
                    .collection("uChat")
                    .document(currentUser.uid)
                
                do {
                    try batch?.setData(from: newChat, forDocument: currentUserChatRef!)
                    try batch?.setData(from: newChat, forDocument: otherUserChatRef!)
                    
                    batch?.commit { error in
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            completion(.success(newChat))
                        }
                    }
                } catch {
                    completion(.failure(error))
                }
            }
    }
    
    func fetchChats(completion: @escaping (Result<[uChat], Error>) -> Void) -> ListenerRegistration? {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "ChatManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "No current user"])))
            return nil
        }
        
        return db.collection("Users")
            .document(userId)
            .collection("uChat")
            .order(by: "lastMessageTimestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                let chats = snapshot?.documents.compactMap { document in
                    try? document.data(as: uChat.self)
                } ?? []
                
                completion(.success(chats))
            }
    }
}
