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
    
     
    private let db: Firestore
    
    init(db: Firestore = Firestore.firestore()) {
        self.db = db
    }
    
     func fetchUser() {
         guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: User not logged in.")
            return
        }
         print("Fetching document for userId: \(userId)")
         
        db.collection("users").document(userId).getDocument { [weak self] snapshot, error in
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
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.isLoggedOut = true
            }
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
