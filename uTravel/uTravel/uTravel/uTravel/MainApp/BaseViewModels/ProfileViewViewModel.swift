//
//  ProfielViewViewModel.swift
//  uTravel
//
//  Created by James Flair on 12/23/24.
//

import FirebaseFirestore
import FirebaseAuth
import Foundation
import SwiftUI

class ProfileViewViewModel: ObservableObject {
    @Published var user: User? = nil
    @Published var isLoggedOut = false
    @Published var errorMessage: String?
    
    private let db: Firestore
    
    init(db: Firestore = Firestore.firestore()) {
        self.db = db
        fetchUser()
    }
    
    func fetchUser() {
        if let currentUser = AuthManager.shared.getCurrentUser() {
            self.user = currentUser
        } else {
            fetchUserFromFirestore()
        }
    }
    
    private func fetchUserFromFirestore() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: User not logged in.")
            return
        }
        
        print("Fetching document for userId: \(userId)")
        
        db.collection("Users")
            .document(userId)
            .getDocument { [weak self] snapshot, error in
                if let error = error {
                    print("Error fetching user document: \(error.localizedDescription)")
                    return
                }
                
                guard let self = self, let data = snapshot?.data() else {
                    print("Error: No data found in user document.")
                    return
                }
                
                DispatchQueue.main.async {
                    self.user = User(
                        id: snapshot?.documentID ?? "",
                        name: data["name"] as? String ?? "",
                        email: data["email"] as? String ?? "",
                        joined: data["joined"] as? TimeInterval ?? Date().timeIntervalSince1970
                    )
                }
            }
    }
    
    func logOut() {
        do {
            try AuthManager.shared.signOut()
            DispatchQueue.main.async {
                self.isLoggedOut = true
            }
        } catch {
            print("Error signing out: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
        }
    }
    

    func signInWithGoogle(presenting viewController: UIViewController) {
        AuthManager.shared.signInWithGoogle(presenting: viewController) { [weak self] result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self?.user = user
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func signInWithApple(presenting viewController: UIViewController) {
        AuthManager.shared.signInWithApple(presenting: viewController) { [weak self] result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self?.user = user
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
