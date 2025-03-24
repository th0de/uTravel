//
//  ToDoListViewViewModel.swift
//  uTravel
//
//  Created by James Flair on 12/23/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreCombineSwift
import Foundation

///View Model for list of items view
///Primarytab
class ToDoListViewViewModel: ObservableObject {
    @Published var showingNewItemView = false
    
    private let userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    /// Delete to do list item
    /// - Parameter id: item id to delete
    func delete(id: String){
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userId)
            .collection("todos")
            .document(id)
            .delete(completion: nil)
    }
}
 
