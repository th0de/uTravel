//
//  uTravelApp.swift
//  uTravel
//
//  Created by James Flair on 12/23/24.
//

import SwiftUI
import Firebase


@main
struct uTravelApp: App {
    @StateObject var viewModel = MainViewViewModel()
    
    init () {
        FirebaseApp.configure()
    }
    
    
    var body: some Scene {
        WindowGroup{
            MainView(userId: viewModel.currentUserId)
        }
    }
}
