//
//  uChatViewModel.swift
//  uTravel
//
//  Created by James Flair on 4/28/25.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreCombineSwift
import FirebaseAuth

class uChatViewModel: ObservableObject {
    @Published var messages = [Message]()
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let chatId: String
    private var messageListener: ListenerRegistration?
    
    init(chatId: String) {
        self.chatId = chatId
        fetchMessages()
    }
    
    deinit {
        messageListener?.remove()
    }
    
    func fetchMessages() {
        isLoading = true
        messageListener = MessageManager.shared.fetchMessages(for: chatId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let messages):
                    self?.messages = messages
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print("Error fetching messages: \(error)")
                }
            }
        }
    }
    
    func sendMessage(text: String, completion: @escaping (Bool) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(false)
            return
        }
        
        let message = Message(
            chatId: chatId,
            senderId: currentUser.uid,
            senderName: currentUser.displayName ?? "Unknown",
            text: text,
            photoURL: currentUser.photoURL?.absoluteString
        )
        
        MessageManager.shared.sendMessage(message) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion(true)
                case .failure(let error):
                    print("Error sending message: \(error)")
                    completion(false)
                }
            }
        }
    }
}
