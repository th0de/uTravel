//
//  MainViewViewModel.swift
//  uTravel
//
//  Created by James Flair on 12/23/24.
//
import FirebaseAuth
import Foundation
import FirebaseAuth
import Firebase
import SwiftUI

class MainViewViewModel: ObservableObject {
    @Published var currentUserId: String = ""
    @Published var navigationPath = NavigationPath()
    
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        self.handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async{
                self?.currentUserId = user?.uid ?? ""
            }
        }
    }
    
    public var isLoggedIn: Bool {
        return Auth.auth().currentUser != nil
    }
}
