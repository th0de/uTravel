//
//  ToDoListItemViewViewModel.swift
//  uTravel
//
//  Created by James Flair on 12/23/24.
//
import FirebaseFirestore
import FirebaseAuth
import Foundation

/// ViewModel for single to do list iltem view (each row in items list)
class ToDoListItemViewViewModel: ObservableObject {
    @Published var showingNewItemView = false
    
    init () {}
    func toggleIsDone(item: ToDoListItem){
        var itemCopy = item
        itemCopy.setDone(!item.isDone)
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(uid)
            .collection("todos")
            .document(itemCopy.id)
            .setData(itemCopy.asDictionary(), completion: nil)
    }
}

