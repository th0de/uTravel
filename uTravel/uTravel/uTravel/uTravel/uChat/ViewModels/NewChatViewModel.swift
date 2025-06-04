//
//  NewChatViewModel.swift
//  uTravel
//
//  Created by James Flair on 5/28/25.
//
import Foundation
import FirebaseAuth
import FirebaseFirestore

class NewChatViewModel: ObservableObject {
    @Published var users = [User]()
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    
    init() {
        fetchUsers()
    }
    
    func fetchUsers() {
        isLoading = true
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("Users")
            .whereField("id", isNotEqualTo: currentUserId)
            .getDocuments { [weak self] snapshot, error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    
                    if let error = error {
                        self?.errorMessage = error.localizedDescription
                        return
                    }
                    
                    self?.users = snapshot?.documents.compactMap { document in
                        try? document.data(as: User.self)
                    } ?? []
                }
            }
    }
}
