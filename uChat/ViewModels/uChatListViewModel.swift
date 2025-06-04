//
//  uChatListViewModel.swift
//  uTravel
//
//  Created by James Flair on 5/28/25.
//
import Foundation
import FirebaseAuth
import FirebaseFirestore

class uChatListViewModel: ObservableObject {
    @Published var chats = [uChat]()
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var chatListener: ListenerRegistration?
    
    init() {
        fetchChats()
    }
    
    deinit {
        chatListener?.remove()
    }
    
    func fetchChats() {
        isLoading = true
        chatListener = ChatManager.shared.fetchChats { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let chats):
                    self?.chats = chats
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func createNewChat(with userId: String, userName: String, completion: @escaping (Result<uChat, Error>) -> Void) {
        ChatManager.shared.createOrGetChat(with: userId, otherUserName: userName) { result in
            DispatchQueue.main.async {
                if case .success = result {
                    self.fetchChats()
                    completion(result)
                }
            }
        }
    }
        
        func deleteChat(_ chat: uChat) {
                guard let userId = Auth.auth().currentUser?.uid else {
                    return 
                }
            let db = Firestore.firestore()
            db.collection("Users")
                .document(userId)
                .collection("uChat")
                .document(chat.id).delete
            { [weak self] error in
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
}
