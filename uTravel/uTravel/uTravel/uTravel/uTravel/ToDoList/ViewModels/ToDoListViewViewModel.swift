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


class ToDoListViewViewModel: ObservableObject {
    @StateObject var viewModel = ProfileViewViewModel()
    @Published var showingNewItemView = false
    
    private let userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    
    func delete(id: String){
        let db = Firestore.firestore()
        
        db.collection("Users")
            .document(userId)
            .collection("todos")
            .document(id)
            .delete(completion: nil)
    }
}
 
