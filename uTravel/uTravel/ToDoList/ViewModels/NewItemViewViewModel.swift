//
//  NewItemViewViewModel.swift
//  uTravel
//
//  Created by James Flair on 12/23/24.
//
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreCombineSwift
import Foundation

class NewItemViewViewModel: ObservableObject {
    @Published var title =  ""
    @Published var dueDate = Date()
    @Published var showAlert = false
    
    init () {}
    
    func save() {
        guard canSave else {
            return
        }
        
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let newId = UUID().uuidString
        let newItem = ToDoListItem(
            id: newId,
            title: title,
            dueDate: dueDate.timeIntervalSince1970,
            createdDate: Date().timeIntervalSince1970,
            isDone: false
        )
        
        let db = Firestore.firestore()
        db.collection("Users")
            .document(userId)
            .collection("todos")
            .document(newId)
            .setData(newItem.asDictionary()) { error in
                if let error = error {
                    print("Error saving document: \(error.localizedDescription)")
                    self.showAlert = true
                } else {
                    print("Document successfully saved.")
                }
            }
    }
    
    var canSave: Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        
        guard dueDate >= Date().addingTimeInterval(-86400) else {
            return false
        }
            
        return true
    }
}
